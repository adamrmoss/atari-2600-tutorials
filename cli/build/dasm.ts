import shell from '../shell';
import { srcPath, outPath } from '../paths';
import { ICommandLineOptions } from './command-line-options';

export function buildRom({ name, verbose }: ICommandLineOptions): void
{
    const inputFilePath       = `${srcPath}/${name}.asm`;
    const listFilePath        = `${outPath}/${name}.lst`;
    const symbolFilePath      = `${outPath}/${name}.sym`;
    const buildOutputFilePath = `${outPath}/${name}.bin`;

    const paths = `-l${listFilePath} -s${symbolFilePath} -o${buildOutputFilePath}`;

    const verbosity = verbose ? '-v1 -DVERBOSE' : '-v0';
    const flags = `-f3 -T1 ${verbosity}`;

    shell(`dasm ${inputFilePath} ${flags} ${paths}`);
}

export function runRom({ name }: ICommandLineOptions): void
{
    shell(`stella ${outPath}/${name}.bin -format NTSC`);
}
