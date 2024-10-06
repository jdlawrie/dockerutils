#!/usr/bin/perl

use warnings;
use strict;

my %running_images;
my %latest_digests;

open my $input, "docker ps --format '{{.Names}} {{.Image}}' |";
while (<$input>) {
	my @name_image = split /\s/;
	$running_images{$name_image[0]} = $name_image[1];
}

open $input, "docker images --no-trunc --digests --format '{{.Repository}}:{{.Tag}} {{.ID}}' |";
while (<$input>) {
	my @name_digest = split /\s/;
	$latest_digests{$name_digest[0]} = $name_digest[1];
}

foreach (keys %running_images) {
	open $input, "docker inspect --format='{{.Image}}' $_ |";
	chomp(my $running_sha = <$input>);
	my $image_name = $running_images{$_};
	my $latest_sha = $latest_digests{$image_name};
	next unless $latest_sha;
	print "$_ is out of date (Running $running_sha instead of $latest_sha\n" unless $running_sha eq $latest_sha;
	print "$_ is up to date\n" if $running_sha eq $latest_sha;
}
