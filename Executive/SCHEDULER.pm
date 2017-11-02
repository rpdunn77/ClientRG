package Executive::SCHEDULER;
#================================================================--
# File Name    : Executive/SCHEDULER.pm
#
# Purpose      : schedular
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;
#no warnings "experimental::smartmatch";

use Exc::Exception;
use Exc::TryCatch;
use Table::QUEUE;
use Table::TASK;
use Table::SEMAPHORE;
use Table::SVAR;
use Executive::EXECUTIONER;

my $cycleComplete = 1;

sub set_cycleComplete {
  my $self = shift @_;
  my $v = shift @_;

  $cycleComplete = $v;

}

sub tick {
   my @keys = Table::TASK->get_keys();
   my $k;
   
   if (!$cycleComplete) {
      die(Exc::Exception->new(name => "Event::SCHEDULER->tick not all tasks executed on the previous cycle"));
   }

   $cycleComplete = 0;

   Table::SVAR->update();

   foreach $k (@keys) {

      if (Table::TASK->get_periodic($k)) { 
         Table::TASK->increment_elapsedTime($k);
         if (!Table::TASK->get_blocked($k)) {
            if (Table::TASK->get_elapsedTime($k) > Table::TASK->get_deadline($k)) {
               die(Exc::Exception->new(name => "Event::SCHEDULER->tick task $k missed deadline"));
            }
            Table::QUEUE->enqueue('task', $k);
         } else {
            if (Table::TASK->get_elapsedTime($k) >= Table::TASK->get_period($k)) {
               Table::TASK->resume($k);
            } 
         }
      } else {
         if (!Table::TASK->get_blocked($k)) {
            Table::QUEUE->enqueue('task', $k);
         }
      }

   }

}

1;
