#! /usr/bin/env perl

my $dir = $ENV{HOME} . "/.config/awesome";
my $config = $ENV{HOME} . "/.config/awesome/rc.lua";
my $config_content;
my $theme;

if (scalar @ARGV > 0) {
    my @all_themes = split "\n", `ls $dir/themes`;
    ($theme) = grep /$ARGV[0]/, @all_themes;
    if ($theme) {
	print "\'$theme\' theme selected\n";
    } else {
	print "No theme found for \'$ARGV[0]\'\n"; 
    }
}

unless($theme) {
    $theme = `ls $dir/themes | fzf`;
    chomp $theme;
}

if ($theme) {
    open(FH, '<' . $config) or die "Unable to open\n";
    while(<FH>) {
	if ($_ =~ /^local chosen_theme/) {
	    $config_content .= "local chosen_theme = \"$theme\"\n";
	    next;
	}
	$config_content .= $_;
    }
    open(FH, '>' . $config) or die "Unable to open\n";
    print FH $config_content;
} else {
    print "No theme selected\n";
}

