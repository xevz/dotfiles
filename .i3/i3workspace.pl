#!/usr/bin/env perl

=head1 SYNOPSIS

Start using

start-stop-daemon --start --make-pidfile --background --pidfile $HOME/.i3/workspace.pid --exec $HOME/.i3/i3workspace.pl

=cut

use strict;
use warnings;

use AnyEvent::I3 qw(:all);

my $i3 = i3();

$i3->connect->recv;

$i3->subscribe({
        workspace => sub {
            my $e = shift;

            my $name = $e->{'current'}->{name};

            if ($name <= 10) {
                $i3->message(TYPE_COMMAND, 'mode default');
            }
            elsif ($name > 10 && $name <= 20) {
                $i3->message(TYPE_COMMAND, 'mode monitor2');
            }
            elsif ($name > 20 && $name <= 30) {
                $i3->message(TYPE_COMMAND, 'mode monitor3');
            }
        }
    })->recv;

AE::cv->recv;

