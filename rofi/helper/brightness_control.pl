#!/usr/bin/env perl

my $config = "$ENV{HOME}/.config/awesome/rofi/helper/config.rasi";

chomp(my $current_brightness = `xbacklight -get`);

my @options = map { "Brightness " . $_ * 10 . "%" } 1 .. 10;
unshift(@options, ("Brightness 1%", "Inc brightness 10%", "Dec brightness 10%"));
push(@options, "Blugon"); # Blue light filter

my $joined_options = join "\n", @options;
my $prompt = "Control brightness ($current_brightness)";
my $rofi_args = qq{-config $config -p "$prompt"};
chomp(my $chosen = `echo "$joined_options" | rofi -dmenu -i $rofi_args`);

unless ($chosen) { exit };

my ($num) = $chosen =~ /(\d+)/; # only digits
my $new_brightness;

if ($chosen =~ /Blugon/) {
    system("blugon && notify-send Blugon");
    exit;
} elsif ($chosen =~ /^a|inc/i) {
    $new_brightness = $current_brightness + $num;
} elsif ($chosen =~ /^d|dec/i) {
    $new_brightness = $current_brightness - $num;
} else {
    $new_brightness = $num;
}

system("xbacklight -set $new_brightness && notify-send Brightness $new_brightness");

