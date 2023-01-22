#! /usr/bin/env perl

my $dir    = $ENV{HOME} . "/.config/awesome";
my $config = $ENV{HOME} . "/.config/awesome/theme.lua";
## use this if you want to use old themes
# my $config = $ENV{HOME} . "/.config/awesome/rc.lua";
my $config_content;
my $theme;

if (scalar @ARGV > 0) {
    my @all_themes = split "\n", `ls $dir/themes`;
    ## use this if you want to use old themes
    # my @all_themes = split "\n", `ls $dir/old-themes`;
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
    # read config
    open(FH, '<' . $config) or die "Unable to open\n";
    while(<FH>) {
        if ($_ =~ /^local chosen_theme/) {
            $config_content .= "local chosen_theme = \"$theme\"\n";
            next;
        }
        $config_content .= $_;
    }
    close(FH);
    # write config
    open(FH, '>' . $config) or die "Unable to open\n";
    print FH $config_content;
    close(FH);
} else {
    print "No theme selected\n";
}

