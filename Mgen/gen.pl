#!/usr/bin/perl
# This program auto-generates Module Makefiles for the inet project
# P Walsh Jan 2016

sub buildMakeTargets {
   my $cut = shift @_;
   my $date = shift @_;
   my $whoami = shift @_;
   my $content;
   
   $content = "# Makefile to drive Perl modules \n"; 
   $content = $content . "# Date auto-generated: " . $date;
   $content = $content . "# By: " . $whoami . "\n";
   $content = $content . "# P Walsh Jan 2016 \n";
   $content = $content . "\n";
   $content = $content .  "# Targets \n";
   $content = $content . "#   bats --- make batch tester from tb.cew \n";
   $content = $content . "#   clean \n";
   $content = $content . "#   cover --- test coverage\n";
   $content = $content . "#   tidy --- indent code in .pl, .pm  and .cew files \n";
   $content = $content . "\n";
   $content = $content . "# directory where scripts are located and temp file\n";
   $content = $content . "SD=../../../Cew\n";
   $content = $content . "CUT=../../$cut\n";
   $content = $content . "\n";
   $content = $content . "# code beautifier \n";
   $content = $content . "INDENT=perltidy -i=3 \n";
   $content = $content . "\n";
   $content = $content . "bats: tb.pl translate\n";
   $content = $content . "\tperl tb.pl\n";
   $content = $content . "\n";
   $content = $content . "translate: \n";
   $content = $content . "\t" . '@((cd ../../../; $(MAKE) translate;) > /dev/null 2>&1)' . "\n";
   $content = $content . "\n";
   $content = $content . "cover: tb.pl \n";
   $content = $content . "\t" . 'perl -MDevel::Cover tb.pl' . "\n";
   $content = $content . "\t" . '@cover -select $(CUT) -report text > $(CUT).cover' . "\n";
   $content = $content . "\t" . '@rm -r cover_db' .  "\n";
   $content = $content . "\n";
   $content = $content . "tb.pl: tb.cew \n";
   $content = $content . "\t" . '@rm -f $(SD)/tmp/tb.num' . "\n";
   $content = $content . "\t" . '@rm -f ./tb.pl' . "\n";
   $content = $content . "\t" . '@awk -f $(SD)/bin/addLineNums.awk tb.cew > $(SD)/tmp/tb.num' . "\n";
   $content = $content . "\t" . '@m4 -I $(SD)/bin $(SD)/tmp/tb.num  | $(INDENT) > tb.pl' . "\n";
   $content = $content . "\n";
   $content = $content . "tb.cew:\n";
   $content = $content . "\t" . '@cp $(SD)/Template/tb.cew .' . "\n";
   $content = $content . "\n";
   $content = $content . "clean:\n";
   $content = $content . "\t" . '@rm -f  $(SD)/tmp/* tb.pl $(CUT).cover *.cover $(CUT).tdy *.tdy *.ERR' . "\n";
   $content = $content . "\n";
   $content = $content . "tidy:\n";
   $content = $content . "\t" . '@$(INDENT) $(CUT) *.pl *.cew' . "\n";
   $content = $content . "\n";
}

sub makeMakefile{
   my $dir = shift @_;

   my @dirSegments = split('/', $dir);
   my $mod = $dirSegments[$#dirSegments] . ".pm";
   my $str = buildMakeTargets($mod, `date`, `whoami`);

   system("rm -f $dir/Makefile");
   open(FH, "> $dir/Makefile") || die "Cant open file \n";
   print(FH $str);
   close(FH);
}

makeMakefile('../Demo/Verification/Lifo');

makeMakefile('../Collection/Verification/Queue');

makeMakefile('../Exc/Verification/Exception');
makeMakefile('../Exc/Verification/TryCatch');

makeMakefile('../Record/Verification/Task');
makeMakefile('../Record/Verification/Semaphore');
makeMakefile('../Record/Verification/SVar');
makeMakefile('../Table/Verification/SVAR');
makeMakefile('../Table/Verification/SEMAPHORE');
makeMakefile('../Table/Verification/TASK');
makeMakefile('../Fsm/Verification/LTO');
