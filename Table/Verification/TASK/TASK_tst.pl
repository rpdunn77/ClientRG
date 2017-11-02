#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/TASK/TASK_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Try::Tiny;
use Exc::Exception;
use Exc::TryCatch;
use Table::TASK;

my $tst = Exc::TryCatch->new(
   fn => sub {
      Table::TASK->new(name => "T1", 
         period => 11, 
         elapsedTime => 0, 
         periodic => 1, 
         deadline => 6,
         fsm => "DUMMY"
      );

      Table::TASK->new(name => "T2", 
         period => 11, 
         elapsedTime => 0, 
         periodic => 1, 
         deadline => 6,
         fsm => "DUMMY"
      );
      
      Table::TASK->dump();

   }
);

$tst->run();
