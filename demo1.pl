package MyPackage;

my $logfile = "Common:1:1:MarketManager:1.log";
my $outputfile = "extracted_lines.txt";

open(LOGFILE, "<", $logfile) or die "Could not open log file: $!";
open(OUTPUTFILE, ">", $outputfile) or die "Could not open output file: $!";

my $in_section = 0;
my $lines_to_extract = 19;
my $lines_extracted = 0;
my $found_match = 0;

while (my $line = <LOGFILE>) {

  if ($line =~ /SMsg: MM_Filter/) {
    $in_section = 1;
  }

  if ($in_section) {
    if ($line =~ /Trading Cycle ID = Standard/) {
      $found_match = 1;
    }

    if ($found_match) {
      print OUTPUTFILE $line;
      $lines_extracted++;
    }

    if ($lines_extracted == $lines_to_extract) {
      $in_section = 0;
      $found_match = 0;
      $lines_extracted = 0;
    }
  }
}

# Print the final values of the in_section, found_match, and lines_extracted variables.
print "Lines extracted: $lines_extracted\n";
print "In section: $in_section\n";
print "Found match: $found_match\n";

close(LOGFILE);
close(OUTPUTFILE);