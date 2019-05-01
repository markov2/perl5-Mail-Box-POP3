# This code is part of distribution Mail-Box-POP3.  Meta-POD processed with
# OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package Mail::Box::POP3s;
use base 'Mail::Box::POP3';

use strict;
use warnings;

=chapter NAME

Mail::Box::POP3s - handle secure POP3 folders as client

=chapter SYNOPSIS

 use Mail::Box::POP3s;
 my $folder = Mail::Box::POP3s->new(folder => $ENV{MAIL}, ...);

=chapter DESCRIPTION

This module mainly extends M<Mail::Box::POP3>.

=chapter METHODS

=c_method new %options

=default server_port  995
=cut

sub init($)
{   my ($self, $args) = @_;
    $args->{server_port} ||= 995;
    $self->SUPER::init($args);
    $self;
}

sub type() {'pop3s'}

#-------------------------------------------

=section Internals
=cut

sub popClient(%)
{   my $self = shift;
    $self->SUPER::popClient(@_, use_ssl => 1);
}

1;
