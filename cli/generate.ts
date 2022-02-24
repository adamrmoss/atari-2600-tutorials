import { createWriteStream } from 'fs';
import { getCommandLineOptions, showHelp } from './base-command-line-options';
import { dataPath, ensureDirectories } from './paths';

import { ICommandLineOptions, optionsDefinitions, usageSections } from './generate/command-line-options';
import { getLengthInBytes, getDataByte } from './generate/data-size';
import { evaluateExpression } from './generate/evaluate-expression';

const options = getCommandLineOptions<ICommandLineOptions>(optionsDefinitions);
const { help, name, expression, length, dataSize } = options;

if (help || !expression || !name)
{
    showHelp(usageSections);
}
else
{
    ensureDirectories();

    console.log(`Generating: ${expression} as ${dataSize}s for 0 ≤ t < ${length}!`);

    const dataSizeInBytes = getLengthInBytes(dataSize);
    const bufferLength = length * dataSizeInBytes;
    const buffer = Buffer.alloc(bufferLength);

    for (let t = 0; t < length; t++)
    {
        const computedValue = evaluateExpression(expression, t);
        console.log(`ComputedValue: ${computedValue}`);

        for (let byteIndex = 0 as 0 | 1; byteIndex < dataSizeInBytes; byteIndex++)
        {
            const byteValue = getDataByte(computedValue, byteIndex);
            buffer[t * dataSizeInBytes + byteIndex] = byteValue;
        }
    }

    const dataFilePath = `${dataPath}/${name}.bin`;
    const writeStream = createWriteStream(dataFilePath);
    writeStream.write(buffer);
    writeStream.end();
}
