import { getCommandLineOptions, showHelp } from './base-command-line-options';
import { ensureDirectories } from './paths';

import { ICommandLineOptions, optionsDefinitions, usageSections } from './generate/command-line-options';
import { getNumberData } from './generate/data-size';
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
    const values = new Array<string>(length);
    for (let t = 0; t < length; t++)
    {
        const computedValue = evaluateExpression(expression, t);
        console.log(`ComputedValue: ${computedValue}`);
        const value = getNumberData(computedValue, dataSize);
        console.log(`Value: ${value}`);
        values[t] = value;
    }
}
