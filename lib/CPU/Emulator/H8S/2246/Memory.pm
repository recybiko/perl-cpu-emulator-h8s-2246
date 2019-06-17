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

sub read16 {
  my ($self, $offset) = @_;
  my $bytes = $self->bytes;
  return unpack('S>', substr $$bytes, $offset, 2);
}

sub read32 {
  my ($self, $offset) = @_;
  my $bytes = $self->bytes;
  return unpack('N', substr $$bytes, $offset, 4);
}

sub read8 {
  my ($self, $offset) = @_;
  my $bytes = $self->bytes;
  return unpack('C', substr $$bytes, $offset, 1);
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

=head2 read16

  my $value = $memory->read16($offset);

Returns the 2 byte (16 bit) value at the specified memory offset.

=head2 read32

  my $value = $memory->read32($offset);

Returns the 4 byte (32 bit) value at the specified memory offset.

=head2 read8

  my $value = $memory->read8($offset);

Returns the byte (8 bit) value at the specified memory offset.

=head1 SEE ALSO

L<CPU::Emulator::H8S::2246>, L<Mojolicious>.

=cut
