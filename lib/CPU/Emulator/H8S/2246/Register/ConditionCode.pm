package CPU::Emulator::H8S::2246::Register::ConditionCode;
use Mojo::Base '-base';

has [qw(
  carry
  half_carry
  interrupt
  negative
  overflow
  user
  user_interrupt
  zero
)] => 0;

1;

=encoding utf8

=head1 NAME

CPU::Emulator::H8S::2246::Register::ConditionCode - Condition Code Register
for the H8S/2246

=head1 SYNOPSIS

  use CPU::Emulator::H8S::2246::Register::ConditionCode;

  my $register = CPU::Emulator::H8S::2246::Register::ConditionCode->new;

=head1 DESCRIPTION

L<CPU::Emulator::H8S::2246::Register::ConditionCode> implements a Condition
Code Register.

=head1 ATTRIBUTES

L<CPU::Emulator::H8S::2246::Register::ConditionCode> implements the following
attributes.

=head2 carry

  my $value = $register->carry;
  $register = $register->carry(1);

A carry has occurred, defaults to 0.

=head2 half_carry

  my $value = $register->half_carry;
  $register = $register->half_carry(1);

A half-carry has occurred, defaults to 0.

=head2 interrupt

  my $value = $register->interrupt;
  $register = $register->interrupt(1);

Mask interrupts except NMI, defaults to 0.

=head2 negative

  my $value = $register->negative;
  $register = $register->negative(1);

Copy of the most significant bit of data, defaults to 0.

=head2 overflow

  my $value = $register->overflow;
  $register = $register->overflow(1);

An overflow has occurred, defaults to 0.

=head2 user

  my $value = $register->user;
  $register = $register->user(1);

User-controllable bit, defaults to 0.

=head2 user_interrupt

  my $value = $register->user_interrupt;
  $register = $register->user_interrupt(1);

Either an interrupt mask or a user-controllable bit, defaults to 0.

=head2 zero

  my $value = $register->zero;
  $register = $register->zero(1);

Data is zero, defaults to 0.

=head1 METHODS

L<CPU::Emulator::H8S::2246::Register::ConditionCode> inherits all methods from
L<Mojo::Base>.

=head1 SEE ALSO

L<CPU::Emulator::H8S::2246>, L<Mojolicious>.

=cut
