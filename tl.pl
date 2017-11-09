#!/usr/bin/perl
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : tl.pl
#
# Purpose      : main routine of the traffic light example
#                containing control only
#                (networked version)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#========================================================
#
$|=1;

$SIG{INT} = sub {leaveScript();};

$SIG{ALRM} = sub {
   Executive::SCHEDULER->tick();
};

use strict;
use warnings;
no warnings "experimental::smartmatch";

use lib './';
use AnyEvent;
use Gtk2 -init;
use IO::Socket;
use Collection::Line;
use Table::QUEUE;
use Table::TASK;
use Table::SEMAPHORE;
use Exc::Exception;
use Exc::TryCatch;
use Try::Tiny;
use Table::SVAR;
use Event::IDLE;
use Executive::TIMER;
use Executive::SCHEDULER;

use Plant::SYSTEM;
use Fsm::CLIENT;
use Fsm::NIC;
use Fsm::TO;
use Table::SVAR;

use constant TRUE => 1;
use constant FALSE => 0;
#timer period in seconds
use constant TIMERPERIOD => 0.01;

my $idle_event;
my $schedular_event;
my $myport = 5071;
my $myserver = 'localhost';
my $clientID = 'TEMPID';

sub leaveScript {
   system("rm -f /tmp/pw*");
   print("\nShutdown Now !!!!! \n");
   exit();
}

my $tl = Exc::TryCatch->new(
   fn => sub {

      Executive::TIMER->set_period(TIMERPERIOD);

      our $line = Collection::Line->new();
      
      print("Enter server Address: ");
      $myserver = <STDIN>;
      chomp $myserver;
      print("Enter ID: ");
      $clientID = <STDIN>;
      chomp $clientID;
      print("Enter port: ");
      $myport = <STDIN>;
      chomp $myport;

      Table::SVAR->add(name => "sv_nicTo", value => 0);
      Table::SVAR->add(name => "sv_regbutton", value => 0);
      Table::SVAR->add(name => "sv_stopbutton", value => 0);
      Table::SVAR->add(name => "sv_clientID", value => 0);


      Table::TASK->new(
         name => "CLIENT", 
         periodic => TRUE, 
         period => Executive::TIMER->s2t(1.0),
         deadline => Executive::TIMER->s2t(1.0),
	 run => TRUE,
         fsm => Fsm::CLIENT->new(
            port => $myport,
            clientID => $clientID
         )
      );

      Table::TASK->new(
         name => "NIC", 
         periodic => TRUE, 
	 period => Executive::TIMER->s2t(0.5),
         deadline => Executive::TIMER->s2t(0.5),
	 run => TRUE,
         fsm => Fsm::NIC->new(
            port => $myport,
            server => $myserver
         )
      );


      Table::TASK->new(
         name => "NICTO", 
         periodic => TRUE, 
	 period => Executive::TIMER->s2t(0.5),
         deadline => Executive::TIMER->s2t(0.5),
	 run => TRUE,
	 fsm => Fsm::TO->new(
            name => "NICTO",
            timeOut => 150,
            svName => "sv_nicTo"
         )
      );

      Event::IDLE->start(\$idle_event);
      Executive::TIMER->start();
      Plant::SYSTEM->start();

      # Now enter Gtk2's event loop
      main Gtk2;

   }
);

$tl->run();
