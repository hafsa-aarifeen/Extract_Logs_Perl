#!usr/bin/perl
use strict;
use warnings;
use Config::IniFiles;

my $config = Config::IniFiles->new('config.ini');

# Get the filter values from the config file.
my $message_pattern = $config->val('filters', 'message_pattern');
my $lines_to_capture = $config->val('filters', 'lines_to_capture');
my $pattern_to_check = $config->val('filters', 'pattern_to_check');

# Get the log file path from the config file.
my $log_file_path = $config->val('log_file', 'file_path');

# Open the log file.
open my $log_fh, '<', $log_file_path or die "Could not open $log_file_path: $!";

# Filter the log file.
my @filtered_lines;
while (my $line = <$log_fh>) {
    if ($line =~ /$message_pattern/) {
        push @filtered_lines, $line;
    }

    if (@filtered_lines == $lines_to_capture && grep {/$pattern_to_check/ } @filtered_lines && grep {/\b${pattern_to_check}\b/ } @filtered_lines) {
        # Output the filtered lines.
        foreach my $line (@filtered_lines) {
            print $line;
        }

        # Clear the filtered lines array.
        @filtered_lines = ();
    }
}

# Close the log file.
close $log_fh;