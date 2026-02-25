#!/usr/bin/env perl
#
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

use strict;

sub print_usage() {
	print <<"EOF";
Usage: timestamp.pl [options] [path...]

Find the newest file under one or more paths, then print selected info
or return a comparison result.

Options:
  -n <name>   Compare mode. Exit 0 if computed name equals <name>, else 1.
  -p          Print only computed name.
  -t          Print only computed Unix timestamp.
  -F          Use newest file path as computed name (default: use input path).
  -x <glob>   Exclude files matching find -path <glob>. Can be used multiple times.
  -f          Follow symlinks during find.
  -h, --help  Show this help message.

Default output (without -n/-p/-t):
  <name>\\t<timestamp>

Examples:
  timestamp.pl .
  timestamp.pl -p package
  timestamp.pl -t scripts package
  timestamp.pl -F -p package
  timestamp.pl -n output/staging_dir/stamp/pkg_compile package src
EOF
}

sub get_ts($$) {
	my $path = shift;
	my $options = shift;
	my $ts = 0;
	my $fn = "";
	$path .= "/" if( -d $path);
	open FIND, "find $path -type f -and -not -path \\*/.svn\\* -and -not -path \\*CVS\\* $options 2>/dev/null |";
	while (<FIND>) {
		chomp;
		my $file = $_;
		next if -l $file;
		my $mt = (stat $file)[9];
		if ($mt > $ts) {
			$ts = $mt;
			$fn = $file;
		}
	}
	close FIND;
	return ($ts, $fn);
}

(@ARGV > 0) or push @ARGV, ".";
my $ts = 0;
my $n = ".";
my %options;
while (@ARGV > 0) {
	my $path = shift @ARGV;
	if ($path eq '-h' || $path eq '--help') {
		print_usage();
		exit 0;
	} elsif ($path =~ /^-x/) {
		my $str = shift @ARGV;
		$options{"findopts"} .= " -and -not -path '".$str."'"
	} elsif ($path =~ /^-f/) {
		$options{"findopts"} .= " -follow";
	} elsif ($path =~ /^-n/) {
		my $arg = $ARGV[0];
		$options{$path} = $arg;
	} elsif ($path =~ /^-/) {
		$options{$path} = 1;
	} else {
		my ($tmp, $fname) = get_ts($path, $options{"findopts"});
		if ($tmp > $ts) {
			if ($options{'-F'}) {
				$n = $fname;
			} else {
				$n = $path;
			}
			$ts = $tmp;
		}
	}
}

if ($options{"-n"}) {
	exit ($n eq $options{"-n"} ? 0 : 1);
} elsif ($options{"-p"}) {
	print "$n\n";
} elsif ($options{"-t"}) {
	print "$ts\n";
} else {
	print "$n\t$ts\n";
}
