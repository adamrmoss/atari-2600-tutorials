import shell from './shell';
import { srcPath, outPath } from './paths';

export function ensureOutputDirectory()
{
    shell(`mkdir -p ${outPath}`);
}

export function buildRom({ name, verbose }: { name: string; verbose: boolean; })
{
    const inputFilePath       = `${srcPath}/${name}.asm`;
    const listFilePath        = `${outPath}/${name}.lst`;
    const symbolFilePath      = `${outPath}/${name}.sym`;
    const buildOutputFilePath = `${outPath}/${name}.bin`;
    const verbosityLevel = verbose ? 1 : 0;

    shell(`dasm ${inputFilePath} -f3 -v${verbosityLevel} -T1 -l${listFilePath} -s${symbolFilePath} -o${buildOutputFilePath}`);
}

export function runRom({ name }: { name: string }) {
    console.log(`${outPath}/${name}.bin`);
    shell(`stella ${outPath}/${name}.bin`);
}
