#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/SEMAPHORE/SEMAPHORE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Try::Tiny;
use Exc::Exception;
use Exc::TryCatch;
use Table::SEMAPHORE;
use Table::TASK;

my $tst = Exc::TryCatch->new(
   fn => sub {
      Table::SEMAPHORE->add(name => "S1");
      Table::SEMAPHORE->add(name => "S2");
      Table::TASK->add(name => "T1", periodic => 1, period => 10, elapsedTime => 3, deadline => 4, fsmPtr => "dummy");
      Table::SEMAPHORE->dump();
      Table::TASK->dump();

      Table::SEMAPHORE->wait(semaphore => "S2", task => "T1");
      
      Table::SEMAPHORE->dump();
      Table::TASK->dump();

   }
);

$tst->run();
