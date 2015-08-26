#!/usr/bin/env perl

use strict;
use warnings;

use AnyEvent;
use AnyEvent::I3 qw(:all);

my $i3 = i3();

$i3->connect->recv or die "Could not connect to i3: $!";

my %callbacks = (
    window => sub {
        my $e = shift;

        return unless $e->{change} eq 'move';
        return unless $e->{container}->{layout};

        if ($e->{container}->{layout} eq 'splith') {
            $i3->message(TYPE_COMMAND, 'split v');
        }

    },
    _error => sub {
        my $msg = shift;

        unless ($msg eq 'Unexpected end-of-file') {
            print STDERR "An error occured: $msg";
            exit 1;
        }

        exit 0;
    }
);

$i3->subscribe(\%callbacks)->recv->{success}
    or die "Could not subscribe to the events: $!";

AE::cv->recv;

