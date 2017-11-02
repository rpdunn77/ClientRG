package Executive::EXECUTIONER;
#================================================================--
# File Name    : Executive/EXECUTIONER.pm
#
# Purpose      : execute scheduled tasks
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use Table::QUEUE;
use Table::TASK;
use Executive::SCHEDULER;

sub tick {

   my $key;
   my $fsm;
   my $res;

   while (Table::QUEUE->get_siz('reset')) {
      $key = Table::QUEUE->dequeue('reset');
      $fsm = Table::TASK->get_fsm($key);
      Table::TASK->set_nextState($key, $fsm->reset());

   }

   while (Table::QUEUE->get_siz('task')) {
      $key = Table::QUEUE->dequeue('task');
      $fsm = Table::TASK->get_fsm($key);
      Table::TASK->set_nextState($key, $fsm->tick(Table::TASK->get_nextState($key)));
   }

   Executive::SCHEDULER->set_cycleComplete(1);
}

1;
