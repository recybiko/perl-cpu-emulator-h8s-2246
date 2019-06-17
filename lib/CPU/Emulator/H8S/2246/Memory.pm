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

sub from_string {
  my ($self, $string) = @_;

  my $bytes = $self->bytes;
  $$bytes = $string;

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

sub read64 {
  my ($self, $offset) = @_;
  my $bytes = $self->bytes;
  return unpack('Q>', substr $$bytes, $offset, 8);
}

sub read8 {
  my ($self, $offset) = @_;
  my $bytes = $self->bytes;
  return unpack('C', substr $$bytes, $offset, 1);
}

sub write16 {
  my ($self, $offset, $value) = @_;

  my $bytes = $self->bytes;
  substr $$bytes, $offset, 2, pack('S>', $value);

  return $self;
}

sub write32 {
  my ($self, $offset, $value) = @_;

  my $bytes = $self->bytes;
  substr $$bytes, $offset, 4, pack('N', $value);

  return $self;
}

sub write64 {
  my ($self, $offset, $value) = @_;

  my $bytes = $self->bytes;
  substr $$bytes, $offset, 8, pack('Q>', $value);

  return $self;
}

sub write8 {
  my ($self, $offset, $value) = @_;

  my $bytes = $self->bytes;
  substr $$bytes, $offset, 1, pack('C', $value);

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

=head2 from_string

  $memory = $memory->from_string($string);

Loads the string into C<bytes>.

=head2 read16

  my $value = $memory->read16($offset);

Returns the 2 byte (16 bit) value at the specified memory offset.

=head2 read32

  my $value = $memory->read32($offset);

Returns the 4 byte (32 bit) value at the specified memory offset.

=head2 read64

  my $value = $memory->read64($offset);

Returns the 8 byte (64 bit) value at the specified memory offset.

=head2 read8

  my $value = $memory->read8($offset);

Returns the byte (8 bit) value at the specified memory offset.

=head2 write16

  $memory = $memory->write16($offset, $value);

Writes the 2 byte (16 bit) value to the specified memory offset.

=head2 write32

  $memory = $memory->write32($offset, $value);

Writes the 4 byte (32 bit) value to the specified memory offset.

=head2 write64

  $memory = $memory->write64($offset, $value);

Writes the 8 byte (64 bit) value to the specified memory offset.

=head2 write8

  $memory = $memory->write8($offset, $value);

Writes the byte (8 bit) value to the specified memory offset.

=head1 SEE ALSO

L<CPU::Emulator::H8S::2246>, L<Mojolicious>.

=cut
