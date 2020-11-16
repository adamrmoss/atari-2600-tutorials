export enum DataSize
{
    byte = 'byte',
    word = 'word',
}

export default DataSize;

export function getNumberData(num: number, dataSize: DataSize): string
{
    switch (dataSize)
    {
        case DataSize.byte: {
            const value = num % 256;
            return numberToHex(value);
        }
        case DataSize.word: {
            const value = num % 65536;
            return numberToHex(value);
        }
    }
}

function numberToHex(num: number)
{
    return num.toString(16);
}
