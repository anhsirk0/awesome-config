#!/usr/bin/env perl

my $browser = $ENV{BROWSER} || "brave";
my $config = "$ENV{HOME}/.config/awesome/rofi/browser/config.rasi";

# for web dev reasons
my $ip_addr = `ip addr`;
my ($lh, $local_ip) = $ip_addr =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/g;

# add your bookmarks here "Title -> url" (" -> " is important)
my @options = (
    "Youtube -> youtube.com/feed/subscriptions",
    "Lichess -> lichess.org",
    "Github -> github.com/anhsirk0",
    "Reddit -> reddit.com",
    "Mail -> mail.yandex.com",
    "fm6000 -> github.com/anhsirk0/fetch-master-6000",
    "network 3000 -> http://" . $local_ip . ":3000",
    "network 4000 -> http://" . $local_ip . ":4000",
    "3000 -> http://localhost:3000",
    "4000 -> http://localhost:4000",
    );

my $joined_options = join "\n", map { (split " -> ", $_)[0] } @options;
my $prompt = "Browser menu";
my $rofi_args = qq{-config $config -p "$prompt"};
chomp(my $chosen = `echo "$joined_options" | rofi -dmenu -i $rofi_args`);

unless ($chosen) { exit };

# match if $chosen is a bookmark
my ($url) = grep { /^$chosen/ } @options;
# shortcuts for search engines (!bang like feature)
my ($key, $query) = $chosen =~ /(^.*?) (.*$)/;

my $message = "$chosen";

if ($url) {
    s/^.* ->// for $url;
    print $url;
} elsif ($key eq "yt") { # Youtube search; for ex: 'yt some video you want'
    $url = "youtube.com/results?search_query=$query";
    $message = qq{Searching youtube for "$query"};
} elsif ($key eq "b") { # Brave search;
    $url = "search.brave.com/search?q=$query";
    $message = qq{Searching brave for "$query"};
} elsif ($key eq "i") { # Yandex reverse image search;
    $url = "yandex.com/images/search?rpt=imageview&url=$query";
    $message = qq{Searching yandex images for "$query"};
} elsif ($key eq "u") { # Just a plain url;
    $url = $query;
    $message = qq{Opening "$query"};
} else {# if not a bookmark or a bang search, then search on ddg;
    $url = "duckduckgo.com/?q=$chosen";
    $message = qq{Searching duckduckgo for "$chosen"};
}

system("notify-send \'$message\'");
system("$browser \'$url\'");
