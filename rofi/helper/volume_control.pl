#!/usr/bin/env perl

my $config = "$ENV{HOME}/.config/rofi/helper/config.rasi";

my $current_volume = `amixer sget Master`;
($current_volume) = $current_volume =~ /\[(\d+)%\]/;

my @options = map { "Volume " . $_ * 10 . "%" } 1 .. 10;
unshift(@options, ("Toggle mute", "Inc volume 10%", "Dec volume 10%"));

my $joined_options = join "\n", @options;
my $prompt = "Control volume ($current_volume)";
my $rofi_args = qq{-config $config -p "$prompt"};
chomp(my $chosen = `echo "$joined_options" | rofi -dmenu -i $rofi_args`);

unless ($chosen) { exit };

my ($num) = $chosen =~ /(\d+)/; # only digits
my $new_volume;

if ($chosen =~ /mute/) {
    system('pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send "Toggled mute"');
    exit;
} elsif ($chosen =~ /^a|inc/i) {
    $new_volume = $current_volume + $num;
} elsif ($chosen =~ /^d|dec/i) {
    $new_volume = $current_volume - $num;
} else {
    $new_volume = $num;
}

my $sink = '@DEFAULT_SINK@';
system("pactl set-sink-volume $sink $new_volume% && notify-send Volume $new_volume");

