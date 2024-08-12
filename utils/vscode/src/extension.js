/*
 * Part of the Carbon Language project, under the Apache License v2.0 with LLVM
 * Exceptions. See /LICENSE for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

const { LanguageClient } = require('vscode-languageclient/node');
const vscode = require('vscode');

function activate(context) {
  // Get the configuration
  const config = vscode.workspace.getConfiguration('languageServer');
  const command = config.get('command', './bazel-bin/language_server/language_server');

  console.log(`Using language server command: ${command}`);

  const serverOptions = {
    run: { command },
    debug: { command },
  };

  const clientOptions = {
    documentSelector: [{ scheme: 'file', language: 'carbon' }],
  };

  const client = new LanguageClient(
    'languageServer',
    'Language Server for Carbon',
    serverOptions,
    clientOptions
  );

  // stop client on shutdown
  context.subscriptions.push(client.start());
}

function deactivate() {}

module.exports = {
  activate,
  deactivate,
};
