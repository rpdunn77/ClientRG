package Fsm::CLIENT;

#================================================================--
# File Name    : Fsm/LIGHT.pm
#
# Purpose      : implements task LIGHT (light selection)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my $myport;
my $myID;
my $starttime;
my $elapsedtime;

sub new {
   my $class  = shift @_;
   my %params = @_;

   my $self = {
      port     => my $port,
      clientID => my $clientID
   };

   if ( defined( $params{port} ) ) {
      $self->{port} = $params{port};
      $myport = $self->{port};
   }
   else {
      die( Exc::Exception->new( port => "Task::CLIENT PORT undefined" ) );
   }

   if ( defined( $params{clientID} ) ) {
      $self->{clientID} = $params{clientID};
      $myID = $self->{clientID};
   }
   else {
      die( Exc::Exception->new( clientID => "Task::CLIENT ID undefined" ) );
   }

   bless( $self, $class );
   return $self;
}

sub tick {
   my $self             = shift @_;
   my $mmt_currentState = shift @_;
   no warnings "experimental::smartmatch";

   my $ns;

   if ( $mmt_currentState ~~ "UNREG" ) {
      my $msg    = $main::line->dequeue_packet();
      my $reg    = Table::SVAR->get_value("sv_regbutton");
      my $regack = Table::SVAR->get_value("sv_regack");
      if ( $reg == 1 ) {
         my $regmsg = "REG_" . $myID . "_" . $myport;
         $main::line->enqueue_packet($regmsg);
         $ns = "WAITREG";
         Table::TASK->reset("REGACKTO");
      }
      elsif ($regack) {
         Plant::SYSTEM->set_lights( "red", "gray", "gray" );
         $ns = "WAITONDECK";
      }
      else {
         $ns = "UNREG";
      }
      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "WAITREG" ) {
      my $regack   = Table::SVAR->get_value("sv_regack");
      my $regackto = Table::SVAR->get_value("sv_regackto");
      if ($regack) {
         Plant::SYSTEM->set_lights( "red", "gray", "gray" );
         $ns = "WAITONDECK";
      }
      elsif ($regackto) {
         Plant::SYSTEM->set_regbutton("grey");
         Table::SVAR->assign( "sv_regbutton", 0 );
         $ns = "UNREG";
      }
      else {
         $ns = "WAITREG";
      }

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "WAITONDECK" ) {
      my $ondeck = Table::SVAR->get_value("sv_ondeck");

      if ($ondeck) {
         Plant::SYSTEM->set_lights( "gray", "yellow", "gray" );
         $ns = "WAITGO";
      }
      else {
         $ns = "WAITONDECK";
      }

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "WAITGO" ) {
      my $go = Table::SVAR->get_value("sv_go");

      if ($go) {
         $ns = "GO";
      }
      else {
         $ns = "WAITONDECK";
      }

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "GO" ) {
      if ( !( defined($starttime) ) ) {
         Plant::SYSTEM->set_lights( "gray", "gray", "green" );
         $starttime = time();
      }
      my $stop = Table::SVAR->get_value("sv_stopbutton");
      if ( $stop == 1 ) {
         my $stoptime = time();
         $elapsedtime = $stoptime - $starttime;
         my $donemsg = "DONE_" . $myport . "_" . $elapsedtime;
         $main::line->enqueue_packet($donemsg);
         $ns = "STOP";
      }
      else {
         $ns = "GO";
      }
      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

   if ( $mmt_currentState ~~ "STOP" ) {
      Plant::SYSTEM->set_lights( "gray", "gray", "gray" );
      $ns = "STOP";

      Table::TASK->suspend("CLIENT");
      return ( $ns );
   }

}

sub reset {
   my $self = shift @_;

   Plant::SYSTEM->set_lights( "gray", "gray", "gray" );
   Plant::SYSTEM->set_regbutton("grey");
   Plant::SYSTEM->set_stopbutton("grey");
   Table::SVAR->assign( "sv_stopbutton", 0 );
   Table::SVAR->assign( "sv_regbutton",  0 );
   Table::SVAR->assign( "sv_regack",     0 );
   Table::SVAR->assign( "sv_ondeck",     0 );
   Table::SVAR->assign( "sv_go",         0 );

   return ("UNREG");
}

1;
