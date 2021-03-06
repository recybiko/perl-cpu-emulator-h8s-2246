use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Memory;

use Mojo::File 'tempfile';

no warnings 'portable';

my $memory = CPU::Emulator::H8S::2246::Memory->new;
isa_ok $memory, 'CPU::Emulator::H8S::2246::Memory';

isa_ok $memory->bytes, 'Mojo::ByteStream';

my $file = tempfile;
$file->spurt(pack('N', 0x1234_ABCD));
$memory->from_file($file->path);
is $memory->bytes, pack('N', 0x1234_ABCD), 'right value';

is $memory->read16(0), 0x1234, 'right value';
is $memory->read16(2), 0xABCD, 'right value';
is $memory->read32(0), 0x1234_ABCD, 'right value';
is $memory->read8(0), 0x12, 'right value';
is $memory->read8(1), 0x34, 'right value';
is $memory->read8(2), 0xAB, 'right value';
is $memory->read8(3), 0xCD, 'right value';

$memory->write16(0, 0xABCD);
is $memory->read16(0), 0xABCD, 'right value';

$memory->write32(0, 0x2345_BCDE);
is $memory->read32(0), 0x2345_BCDE, 'right value';

$memory->write8(0, 0xFE);
is $memory->read8(0), 0xFE, 'right value';

is $memory->write64(0, 0x1234_ABCD_FEDC_9876)->read64(0),
  0x1234_ABCD_FEDC_9876, 'right value';

is $memory->from_string(pack('N', 0x12AB_34CD))->read32(0), 0x12AB_34CD,
  'right value';

done_testing;
