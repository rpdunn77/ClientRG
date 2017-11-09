package Plant::SYSTEM;
#================================================================--
# File Name    : PLANT/SYSTEM.pm
#
# Purpose      : traffic light physical plant
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

use strict;
use warnings;
use Widgit::Light;
use Widgit::Sensor;
use constant FALSE => 0;
use constant TRUE => 1;
use Table::SVAR;

my $notificationRed;
my $notificationYellow;
my $notificationGreen;
my $regLight;
my $stopLight;

sub leaveScript {
   exit();
}


sub start {
   
   # create reg window 

   my $regWindow = new Gtk2::Window "toplevel";
   $regWindow->set_title('register');
   $regWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $regWindow->set_resizable(FALSE);

   # create a reg sensor and reg light

   $regLight = Widgit::Light->new(header => "Sensor");
   my $regSensor = Widgit::Sensor->new(
      markup => "<big> <big> Register</big> </big>",
      cb => sub {
         if (Table::SVAR->get_value("sv_regbutton")) {
            Table::SVAR->assign("sv_regbutton", 0);
            $regLight->set_light('gray');
	 } else {
            Table::SVAR->assign("sv_regbutton", 1);
            $regLight->set_light('black');
         }
      }
   );

   # create vbox and place  reg button  and light in vbox

   my $regVbox = Gtk2::VBox->new( FALSE, 3 );
   $regVbox->set_border_width(50);
   $regVbox->pack_start($regLight->get_canvas(), FALSE, FALSE, 0);
   $regVbox->pack_start($regSensor->get_button(), FALSE, FALSE, 0);

   $regWindow->add($regVbox);
   
   # create stop window 

   my $stopWindow = new Gtk2::Window "toplevel";
   $stopWindow->set_title('Stop');
   $stopWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $stopWindow->set_resizable(FALSE);

   # create a stop sensor and stop light

   $stopLight = Widgit::Light->new(header => "Sensor");
   my $stopSensor = Widgit::Sensor->new(
      markup => "<big> <big> Click Me </big> </big>",
      cb => sub {
         if (Table::SVAR->get_value("sv_stopbutton")) {
            Table::SVAR->assign("sv_stopbutton", 0);
            $stopLight->set_light('gray');
	 } else {
            Table::SVAR->assign("sv_stopbutton", 1);
            $stopLight->set_light('black');
         }
      }
   );

   # create vbox and place  stop button  and light in vbox

   my $stopVbox = Gtk2::VBox->new( FALSE, 3 );
   $stopVbox->set_border_width(50);
   $stopVbox->pack_start($stopLight->get_canvas(), FALSE, FALSE, 0);
   $stopVbox->pack_start($stopSensor->get_button(), FALSE, FALSE, 0);

   $stopWindow->add($stopVbox);
   

   # create notification window

   my $notificationWindow = new Gtk2::Window "toplevel";
   $notificationWindow->set_title('Notification');
   $notificationWindow->signal_connect( 'destroy' => sub {leaveScript();});
   $notificationWindow->set_resizable(FALSE);

   # create  notification lights

   $notificationRed=Widgit::Light->new(header => "Red");
   $notificationGreen=Widgit::Light->new(header => "Green");
   $notificationYellow=Widgit::Light->new(header => "Amber");

   # create vbox and place  notification lights  in vbox

   my $notificationVbox = Gtk2::VBox->new( FALSE, 3 );
   $notificationVbox->pack_start($notificationRed->get_canvas(),FALSE,FALSE,0);
   $notificationVbox->pack_start($notificationYellow->get_canvas(),FALSE,FALSE,0);
   $notificationVbox->pack_start($notificationGreen->get_canvas(),FALSE,FALSE,0);
   $notificationWindow->add($notificationVbox);

   # initialize notification lights

   $notificationRed->set_light('gray');
   $notificationYellow->set_light('gray');
   $notificationGreen->set_light('gray');
   $regLight->set_light('gray');
   $stopLight->set_light('gray');
   

   $notificationWindow->show_all;
   $regWindow->show_all;
   $stopWindow->show_all;

}

sub set_lights {
   my $class = shift @_;
   my @params = @_;

   $notificationRed->set_light($params[0]);
   $notificationYellow->set_light($params[1]);
   $notificationGreen->set_light($params[2]);
}

sub set_regbutton {
   my $class = shift @_;
   my @params = @_;

   $regLight->set_light($params[0]);
}

sub set_stopbutton {
   my $class = shift @_;
   my @params = @_;

   $stopLight->set_light($params[0]);
}

1;
