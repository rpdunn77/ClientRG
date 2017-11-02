#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/SVAR/SVAR_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Try::Tiny;
use Exc::Exception;
use Exc::TryCatch;
use Table::SVAR;

my $tst = Exc::TryCatch->new(
   fn => sub {
      Table::SVAR->add(name => "var1", 
         currentValue => 1, 
         nextValue => 0 
      );

      Table::SVAR->add(name => "var2", 
         currentValue => 8, 
         nextValue => 7 
      );
      
      Table::SVAR->dump();


      Table::SVAR->update();

      Table::SVAR->dump();

   }
);

$tst->run();
