use Mojo::Base -strict;

use Test::More;

use CPU::Emulator::H8S::2246::Memory;

use Mojo::File 'tempfile';

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

done_testing;
