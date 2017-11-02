package Table::TASK;
#================================================================--
# File Name    : Table/TASK.pm
#
# Purpose      : table of Task records
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use Record::Task;
use Exc::Exception;
use Table::SEMAPHORE;
use Table::SVAR;
use Table::QUEUE;

my %table;

sub get_keys {

   return keys(%table);
}

sub new {
   my $pkg = shift @_;
   my %params = @_;

   if (defined($params{name})) {
      if (!exists($table{$params{name}})) {
         $table{$params{name}} = Record::Task->new();
         $table{$params{name}}->set_name($params{name});
      } else {
         die(Exc::Exception->new(name => "Table::TASK->new name duplicate"));
      }
   } else {
      die(Exc::Exception->new(name => "Table::TASK->new name undefined"));
   }

   if (defined($params{periodic})) {
      $table{$params{name}}->set_periodic($params{periodic});
   } else {
      die(Exc::Exception->new(name => "Table::TASK->new periodic undefined"));
   }

   if ($params{periodic}) {
      if (defined($params{period})) {
         $table{$params{name}}->set_period($params{period});
      } else {
         die(Exc::Exception->new(name => "Table::TASK->new period undefined"));
      }

      if (defined($params{deadline})) {
         $table{$params{name}}->set_deadline($params{deadline});
      } else {
         die(Exc::Exception->new(name => "Table::TASK->new deadline undefined"));
      }
   } 

   if (defined($params{elapsedTime})) {
      $table{$params{name}}->set_elapsedTime($params{elapsedTime});
   } 

   if (defined($params{fsm})) {
      $table{$params{name}}->set_fsm($params{fsm});
   } else {
      die(Exc::Exception->new(name => "Table::TASK->new  fsm undefined"));
   }

   if (($table{$params{name}}->get_periodic()) && ($table{$params{name}}->get_period() < $table{$params{name}}->get_deadline())) {
      die(Exc::Exception->new(name => "Table::TASK->new $params{name} period > deadline"));
   }

   Table::SVAR->add(name => $params{name}, value => 0, nextValue => 0);
   Table::SEMAPHORE->add(name => $params{name}, value => 0, max => 0);

   Table::TASK->reset($params{name});
   Table::TASK->suspend($params{name});

   Table::SVAR->update();

   if (defined($params{run}) && $params{run}) {
      Table::TASK->resume($params{name});
   }

}

sub reset {
   my $pkg = shift @_;
   my $name = shift @_;


   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->reset name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->reset name = $name not in table"));
   }

   Table::QUEUE->enqueue('reset', $name);
}

sub resume {
   my $pkg = shift @_;
   my $name = shift @_;


   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->resume name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->resume name = $name not in table"));
   }

   # if not blocked
   if (!Table::SVAR->get_value($name)) {
      die(Exc::Exception->new(name => "Table::TASK->resume $name is not blocked"));
   }

   Table::SEMAPHORE->signal(semaphore => $name);
   $table{$name}->set_elapsedTime(0);

}

sub suspend {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->resume name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->resume name = $name not in table"));
   }

   # if blocked
   if (Table::SVAR->get_value($name)) {
      die(Exc::Exception->new(name => "Table::TASK->suspend $name is blocked"));
   }

   Table::SEMAPHORE->wait(semaphore => $name, task => $name);
}

#===================================


sub get_nextState {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->get_nextState name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->get_nextState name = $name not in table"));
   }

   return ($table{$name}->get_nextState());
}

sub set_nextState {
   my $pkg = shift @_;
   my $name = shift @_;
   my $state = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->set_nextState name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->set_nextState name = $name not in table"));
   }

   $table{$name}->set_nextState($state);
   return;
}


sub get_period {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->get_period name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->get_period name = $name not in table"));
   }

   return ($table{$name}->get_period());
}

sub get_periodic {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->get_periodic name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->get_periodic name = $name not in table"));
   }

   return ($table{$name}->get_periodic());
}

sub get_elapsedTime {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->get_elapsedTime name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->get_elapsedTime name = $name not in table"));
   }

   return ($table{$name}->get_elapsedTime());
}

sub get_fsm {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->get_fsm name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->get_fsm name = $name not in table"));
   }

   return ($table{$name}->get_fsm());
}

sub get_deadline {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->get_deadline name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->get_deadline name = $name not in table"));
   }

   return ($table{$name}->get_deadline());
}

sub get_blocked {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->get_blocked name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->get_blocked name = $name not in table"));
   }

   return (Table::SVAR->get_value($name));
}

sub set_blocked {
   my $pkg = shift @_;
   my $name = shift @_;
   my $b = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->set_blocked name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->set_blocked name = $name not in table"));
   }

   Table::SVAR->assign($name, $b);
}

sub increment_elapsedTime {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->increment_elapsedTime name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->increment_elapsedTime name $name not in table"));
   }

   my $t = $table{$name}->get_elapsedTime();
   $table{$name}->set_elapsedTime($t+1);
}

sub clear_elapsedTime {
   my $pkg = shift @_;
   my $name = shift @_;

   if (!defined($name)) {
      die(Exc::Exception->new(name => "Table::TASK->clear_elapsedTime name undefined"));
   }

   if (!exists($table{$name})) {
      die(Exc::Exception->new(name => "Table::TASK->clear_elapsedTime name $name not in table"));
   }

   $table{$name}->set_elapsedTime(0);
}


sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Name: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}

1;
