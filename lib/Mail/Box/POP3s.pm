#oodist: *** DO NOT USE THIS VERSION FOR PRODUCTION ***
#oodist: This file contains OODoc-style documentation which will get stripped
#oodist: during its release in the distribution.  You can use this file for
#oodist: testing, however the code of this development version may be broken!

package Mail::Box::POP3s;
use parent 'Mail::Box::POP3';

use strict;
use warnings;

use Log::Report  'mail-box-pop3';

#--------------------
=chapter NAME

Mail::Box::POP3s - handle secure POP3 folders as client

=chapter SYNOPSIS

  use Mail::Box::POP3s;
  my $folder = Mail::Box::POP3s->new(folder => $ENV{MAIL}, ...);

=chapter DESCRIPTION

This module mainly extends Mail::Box::POP3.

=chapter METHODS

=c_method new %options
=default server_port  995
=cut

sub init($)
{	my ($self, $args) = @_;
	$args->{server_port} ||= 995;
	$self->SUPER::init($args);
	$self;
}

sub type() {'pop3s'}

#--------------------
=section Internals
=cut

sub popClient(%)
{	my $self = shift;
	$self->SUPER::popClient(@_, use_ssl => 1);
}

1;
