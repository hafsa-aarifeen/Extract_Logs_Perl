#!/usr/bin/perl
use strict;
use warnings;

my $inside_section = 0;

my $config_file = '/x01/exch/hafsalog/config.ini';

my $cfg = Config::IniFiles->new( -file => $config_file );

my $message_pattern = $cfg->val('filters', 'message_pattern');
my $lines_to_capture = $cfg->val('filters', 'lines_to_capture');
my $pattern_to_check = $cfg->val('filters', 'pattern_to_check');

my $log_file = shift;

open my $log_fh, '<', $log_file or die "Could not open $log_file: $!";

my @section = ();

while (my $line = <$log_fh>) {
    if ($line =~ /$message_pattern/) {
        $inside_section = 1;
        @section = ();
    }

    if ($inside_section) {
        push @section, $line;

        if (@section == $lines_to_capture && grep {/$pattern_to_check/ } @section && grep {/\b${pattern_to_check}\b/ } @section) {
            foreach my $output_line (@section) {
                print $output_line;
            }

            @section = ();
            $inside_section = 0;
        }
    }
}

close $log_fh;

if (@section == 0) {
    print "$message_pattern not found in the log file.\n";
}