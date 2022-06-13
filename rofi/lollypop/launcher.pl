#!/usr/bin/perl -w

my $db = "$ENV{HOME}/.local/share/lollypop/lollypop.db";
my $config = "$ENV{HOME}/.config/awesome/rofi/lollypop/config.rasi";
my $query = q{select tracks.id, tracks.name, artists.name from tracks
              join track_artists on track_artists.track_id = tracks.id
              join artists on track_artists.artist_id = artists.id
              order by popularity desc;};

my @all = split "\n", `echo "$query" | sqlite3 $db`;

my %seen = ();
my @songs = grep { ! $seen{substr $_, 0, 3} ++ } @all;

my @names = ("Play next");
my %ids = ();

# refactoring names
foreach $song (@songs) {
    # s/Ft.*\|/|/g, s/\(.*?\)//g, s/\|/+/, s/\|/ -  / for $song;
    s/\|/+/, s/\|/ -  / for $song;
    my @temp = split('\+', $song);
    $ids{$temp[1]} = $temp[0];
    push(@names, $temp[1]);
}

# get current playing song
my ($song, $artist) = grep /title|artist/, split "\n", `pactl list`;
s/.*?\"//, s/\(.*?\)|\"//g, s/\s+$//, chomp for $song, $artist;
$artist =~ s/ & /, /;

# add current song info to rofi menu placeholder
open(FH, '<' . $config) or die "Unable to open\n";
while(<FH>) {
    if ($_ =~ /place/) {
        my $placeholder = "\t" x 12 . "  $song - $artist";
        $_ =~ s/\".*\"/\"$placeholder\"/;
    }
    $file .= $_;
}
open(FH, '>' . $config) or die "Unable to open\n";
print FH $file;

my $total = scalar %ids;
my $joined_names = join "\n", @names;
my $rofi_args = "-p 'Add song to Queue ($total)' -i -config $config";
chomp(my $var = `echo "$joined_names" | rofi -dmenu $rofi_args`);

unless ($var) { exit }
if($var eq "Play next") {
    system('notify-send "Next"; lollypop -n');
} else {
    my ($song, $artist) = split "-", $var;
    system(qq{notify-send "=> $song" "$artist"; lollypop -m $ids{$var}});
}

