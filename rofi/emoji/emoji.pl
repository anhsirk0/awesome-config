#!/usr/bin/env perl

my $config = "$ENV{HOME}/.config/awesome/rofi/emoji/config.rasi";
my $rofi_args = qq{-dmenu -i -config $config -p "Select emoji"};
my $emoji_file = "$ENV{HOME}/.config/awesome/rofi/emoji/emojis.txt";

chomp(my $chosen = `cat "$emoji_file" | rofi $rofi_args`);

unless ($chosen) { exit };

my $emoji = (split "\t", $chosen)[0];
print $emoji . "\n";
my $message = "$emoji 'copied to clipboard'";
system("printf $emoji | xsel --input --clipboard && notify-send $message");
