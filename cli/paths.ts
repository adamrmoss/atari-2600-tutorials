import shell from './shell';

export const srcPath = 'src';
export const libPath = 'lib';
export const dataPath = 'data';
export const outPath = 'out';

export function ensureDirectories(): void
{
    ensureDirectory(srcPath);
    ensureDirectory(libPath);
    ensureDirectory(dataPath);
    ensureDirectory(outPath);
}

function ensureDirectory(path: string): void
{
    shell(`mkdir -p ${path}`);
}
