import shell from './shell';

export function buildRom({ srcPath, name }: { srcPath: string; name: string; })
{
    const inputFilePath       = `${srcPath}/${name}.asm`;
    const listFilePath        = `out/${name}.lst`;
    const symbolFilePath      = `out/${name}.sym`;
    const buildOutputFilePath = `out/${name}.bin`;

    buildBinary({ inputFilePath, listFilePath, symbolFilePath, buildOutputFilePath });
}

export type BuildBinaryParams =
{
    inputFilePath: string,
    listFilePath: string,
    symbolFilePath: string,
    buildOutputFilePath: string
};

export function buildBinary({ inputFilePath, listFilePath, symbolFilePath, buildOutputFilePath }: BuildBinaryParams)
{
    shell(`dasm ${inputFilePath} -f3 -v1 -T1 -l${listFilePath} -s${symbolFilePath} -o${buildOutputFilePath}`);
}
