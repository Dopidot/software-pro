/**
 * Author : Guillaume Tako
 * StringUtils
 */

/**
 * Process the path string to remove the last directory
 * @param path : path from a process.cwd() function
 */
export function removeLastDirectoryFromCWDPath(path: string): string {
    const array: string[] = path.split('/');
    console.log(array);
    array.pop();
    return array.join('/');
}