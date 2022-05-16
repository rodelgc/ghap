const { readFile, writeFile } = require("fs");

const someFile = "text.txt";
const replacement = "Merge branch 'trunk' into e2e/rep-gh-pages";

readFile(someFile, "utf8", (err, fileContent) => {
  if (err) {
    return console.log(err);
  }
  const newFileContent = fileContent.replace(/Allure Report/g, replacement);

  writeFile(someFile, newFileContent, "utf8", (err) => {
    if (err) return console.log(err);
  });
});
