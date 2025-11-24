#oodist: *** DO NOT USE THIS VERSION FOR PRODUCTION ***
#oodist: This file contains OODoc-style documentation which will get stripped
#oodist: during its release in the distribution.  You can use this file for
#oodist: testing, however the code of this development version may be broken!

package Mail::Box::POP3::Message;
use base 'Mail::Box::Net::Message';

use strict;
use warnings;

use Log::Report  'mail-box-pop3';

#--------------------
=chapter NAME

Mail::Box::POP3::Message - one message on a POP3 server

=chapter SYNOPSIS

  my $folder = new Mail::Box::POP3 ...
  my $message = $folder->message(10);

=chapter DESCRIPTION

A C<Mail::Box::POP3::Message> represents one message on a POP3 server,
maintained by a Mail::Box::POP3 folder. Each message is stored as
separate entity on the server, and maybe temporarily in your program
as well.

=chapter METHODS

=c_method new %options

=default body_type Mail::Message::Body::Lines
=cut

sub init($)
{	my ($self, $args) = @_;
	$args->{body_type} ||= 'Mail::Message::Body::Lines';
	$self->SUPER::init($args);
}

=method size
Returns the size of this message.  If the message is still on the remote
server, POP is used to ask for the size.  When the message is already loaded
onto the local system, the size of the parsed message is taken.  These
sizes can differ because the difference in line-ending representation.
=cut

sub size($)
{	my $self = shift;
	$self->isDelayed
	  ? $self->folder->popClient->messageSize($self->unique)
	  : $self->SUPER::size;
}

sub label(@)
{	my $self = shift;
	$self->loadHead;              # be sure the labels are read
	return $self->SUPER::label(@_) if @_==1;

	# POP3 can only set 'deleted' in the source folder.  Don't forget
	my $olddel = $self->label('deleted') ? 1 : 0;
	my $ret    = $self->SUPER::label(@_);
	my $newdel = $self->label('deleted') ? 1 : 0;

	$self->folder->popClient->deleted($newdel, $self->unique)
		if $newdel != $olddel;

	$ret;
}

sub labels(@)
{	my $self = shift;
	$self->loadHead;              # be sure the labels are read
	$self->SUPER::labels(@_);
}

#--------------------
=section Internals
=cut

sub loadHead()
{	my $self     = shift;
	my $head     = $self->head;
	$head->isDelayed or return $head;

	$head        = $self->folder->getHead($self);
	$self->head($head);

	$self->statusToLabels;  # not supported by al POP3 servers
	$head;
}

sub loadBody()
{	my $self     = shift;

	my $body     = $self->body;
	$body->isDelayed or return $body;

	(my $head, $body) = $self->folder->getHeadAndBody($self);
	$self->head($head) if $head->isDelayed;
	$self->storeBody($body);
}

1;
