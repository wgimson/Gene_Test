# projectOne.pl

# NOTE: This program was written and tested on my home 
# system where Perl 5.10 is native. I hope there are no
# conflicts with the interpreter on the snowball machine.

use warnings;
use strict;

do {
    
    print "\n";
    print "Enter an option from the menu below:                             \n";
    print "-----------------------------------------------------------------\n";
    print "   cr - complement and reverse                                 \\\n";
    print "   cw - create windows                                         \\\n";
    print "   gr - get reads                                              \\\n";
    print "   ww - write windows                                          \\\n";
    print "   q -  quit                                                   \\\n";
    print "-----------------------------------------------------------------\n";

    $main::userInput = <stdin>;
    chomp($main::userInput);

    if ($main::userInput eq "cr" || $main::userInput eq "CR") {
        
       print "\nPlease enter a series of characters consisting solely of",
              " A, G, C and T.\t";
        $main::stringToComplement = <STDIN>;

        $main::watsonCrickComplement = 
        complement_and_reverse($main::stringToComplement);
        
        print "\n\n", $main::watsonCrickComplement, "\n\n";

    } elsif ($main::userInput eq "cw" || $main::userInput eq "CW") {

        print "\nPlease enter a series of characters consisting solely", 
              " of A, G, C and T.\t";
        $main::stringToWindow = <STDIN>;

        print "\nPlease enter a window size (integer).\t";
        $main::windowSize = <STDIN>;

        print "\nPlease enter a sliding amount (integer).\t";
        $main::slidingAmount = <STDIN>;

        @main::windowedStrings = create_windows($main::stringToWindow,
            $main::windowSize, $main::slidingAmount);

        print "\n", @main::windowedStrings,;
        print "\n";

    } elsif ($main::userInput eq "gr" || $main::userInput eq "GR") {

        print "\nPlease enter the path to the file you would like to check for", 
        " valid strings, sans quotation marks.\t";
        $main::readPath = <STDIN>;
        chomp($main::readPath);

        @main::validStringList = get_reads($main::readPath);

        if (@main::validStringList) {
            print "\n\n", @main::validStringList;

        } else {
            print "\nError: invalid file path\n";
        }

    } elsif ($main::userInput eq "ww" || $main::userInput eq "WW") {

        print "\nPlease enter the path to the file you would like to write to",
              ", sans quotation marks.\t";
        $main::writePath = <STDIN>;
        chomp($main::writePath);

        print "\nPlease enter the strings to be written to file consecutively",
              " separated only by whitespace.\t";
        $main::stringList = <STDIN>;
        
        @main::stringArray = split(" ", $main::stringList);

        my $result = write_windows($main::writePath, @main::stringArray);

        if ($result == 1) {
            print "\nError: invalid file path\n";
        }

    } elsif ($main::userInput ne "q" && $main::userInput ne "Q") {
        print "\nError: invalid input\n";
    }

} while ($main::userInput ne "q" && $main::userInput ne "Q");

print "\n\nYou have elected to exit the program; Goodbye.\n\n";

sub complement_and_reverse {

    my $geneSequence = $_[0];
    my $reversedString = "";

    if ($geneSequence =~ /^[AGCTagct][AGCTagct]*[AGCTagct]$/) {
        $geneSequence =~ tr/AGCTagct/CTAGctag/;
    } else {
        
        print "\nError: invalid string";
        return $reversedString;

    }

    for (my $i = length($geneSequence); $i >= 0; $i--) {
        
        my $singleChar = chop($geneSequence);
        $reversedString = $reversedString.$singleChar;
    }

    return($reversedString);

}

sub create_windows {

    my ($string, $windowSize, $slideAmount) = (shift, shift, shift);
    my $newString;
    my $i = 0;
    my @windowedStrings;
    chomp($string);

    if (($string =~ /^[AGCTagct][AGCTagct]*[AGCTagct]$/) && 
        ($windowSize =~ /^[0-9][0-9]*[0-9]?$/) && 
        ($slideAmount =~ /^[0-9][0-9]*[0-9]?$/)) {

        do {

            $newString = substr($string, $i, $windowSize);
            push (@windowedStrings, "$newString ");
            $i += $slideAmount;

        } while ((length($string)-$i) >= 1);

        return @windowedStrings;

    } else {

        print "\nError: invalid input";
        
        @windowedStrings = ();
        return @windowedStrings;

    }
}

sub get_reads {

    my $filePath = shift;
    my @validLines;

    open FILE, $filePath or return (@validLines = ());

    while (<FILE>) {
        if ($_ =~ /^[AGCTagct][AGCTagct]*[AGCTagct]$/) {
            push(@validLines, "$_\n");
        }
    }

    return @validLines;

}

sub write_windows {

    my $filePath = shift;
    my $window;

    open FILE, ">$filePath" or return (1);

    foreach $window (@_) {
        print FILE $window, "\n";
    }

    return (0);

}
