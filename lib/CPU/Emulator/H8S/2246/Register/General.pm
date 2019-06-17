package CPU::Emulator::H8S::2246::Register::General;
use Mojo::Base '-base';

has _value => 0;

sub read16h {
  my $self = shift;
  my $value = ($self->_value >> 16) & 0xFFFF;
  return $value;
}

sub read16l {
  my $self = shift;
  my $value = $self->_value & 0xFFFF;
  return $value;
}

sub read32 {
  my $self = shift;
  my $value = $self->_value & 0xFFFF_FFFF;
  return $value;
}

sub write16h {
  my ($self, $value) = @_;
  $value = ($value << 16) & 0xFFFF_0000;
  my $masked_value = $self->_value & 0xFFFF;
  my $new_value = $masked_value | $value;
  return $self->_value($new_value);
}

sub write16l {
  my ($self, $value) = @_;
  $value = $value & 0xFFFF;
  my $masked_value = $self->_value & 0xFFFF_0000;
  my $new_value = $masked_value | $value;
  return $self->_value($new_value);
}

sub write32 {
  my ($self, $value) = @_;
  $value = $value & 0xFFFF_FFFF;
  return $self->_value($value);;
}

1;

=encoding utf8

=head1 NAME

CPU::Emulator::H8S::2246::Register::General - General Register for the
H8S/2246

=head1 SYNOPSIS

  use CPU::Emulator::H8S::2246::Register::General;

  my $register = CPU::Emulator::H8S::2246::Register::General->new;
  $register->write32(1024);
  my $value = $register->read32;

=head1 DESCRIPTION

L<CPU::Emulator::H8S::2246::Register::General> implements a General Register.

=head1 METHODS

L<CPU::Emulator::H8S::2246::Register::General> inherits all methods from
L<Mojo::Base> and implements the following new ones.

=head2 read16h

  my $value = $register->read16h;

Returns the highest 2 bytes (16 bits) of the register.

=head2 read16l

  my $value = $register->read16l;

Returns the lowest 2 bytes (16 bits) of the register.

=head2 read32

  my $value = $register->read32;

Returns the lowest 4 bytes (32 bits) of the register.

=head2 write16h

  my $register = $register->write16h(1024);

Writes the lowest 2 bytes (16 bits) of the provided value to the highest 2
bytes (16 bits) of the register.

=head2 write16l

  my $register = $register->write16l(1024);

Writes the lowest 2 bytes (16 bits) of the provided value to the lowest 2
bytes (16 bits) of the register.

=head2 write32

  my $register = $register->write32(1024);

Writes the lowest 4 bytes (32 bits) of the provided value to the register.

=head1 SEE ALSO

L<CPU::Emulator::H8S::2246>, L<Mojolicious>.

=cut
