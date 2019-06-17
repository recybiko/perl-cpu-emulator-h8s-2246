package CPU::Emulator::H8S::2246::Memory;
use Mojo::Base '-base';

use Mojo::ByteStream;
use Mojo::File;

has bytes => sub { Mojo::ByteStream->new };

sub from_file {
  my ($self, $path) = @_;

  my $bytes = $self->bytes;
  $$bytes = Mojo::File->new($path)->slurp;

  return $self;
}

1;

=encoding utf8

=head1 NAME

CPU::Emulator::H8S::2246::Memory - Memory for the H8S/2246 CPU

=head1 SYNOPSIS

  use CPU::Emulator::H8S::2246::Memory;

  my $memory = CPU::Emulator::H8S::2246::Memory->new;
  $memory->from_file($path);

=head1 DESCRIPTION

L<CPU::Emulator::H8S::2246::Memory> implements memory for the H8S/2246 CPU.

=head1 ATTRIBUTES

L<CPU::Emulator::H8S::2246::Memory> implements the following attributes.

=head2 bytes

  my $bytes = $memory->bytes;
  $memory = $memory->bytes(Mojo::ByteStream->new);

Memory values, defaults to a L<Mojo::ByteStream> object.

=head1 METHODS

L<CPU::Emulator::H8S::2246::Memory> inherits all methods from L<Mojo::Base>
and implements the following new ones.

=head2 from_file

  $memory = $memory->from_file($path);

Loads the specified file into C<bytes>.

=head1 SEE ALSO

L<CPU::Emulator::H8S::2246>, L<Mojolicious>.

=cut
