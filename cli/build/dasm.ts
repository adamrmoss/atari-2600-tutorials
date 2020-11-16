import shell from '../shell';
import { srcPath, outPath } from '../paths';

export function buildRom({ name, verbose }: { name: string; verbose: boolean; }): void
{
    const inputFilePath       = `${srcPath}/${name}.asm`;
    const listFilePath        = `${outPath}/${name}.lst`;
    const symbolFilePath      = `${outPath}/${name}.sym`;
    const buildOutputFilePath = `${outPath}/${name}.bin`;
    const verbosity = verbose ? '-v1 -DVERBOSE' : '-v0';

    shell(`dasm ${inputFilePath} -f3 ${verbosity} -T1 -l${listFilePath} -s${symbolFilePath} -o${buildOutputFilePath}`);
}

export function runRom({ name }: { name: string }): void
{
    console.log(`${outPath}/${name}.bin`);
    shell(`stella ${outPath}/${name}.bin`);
}
