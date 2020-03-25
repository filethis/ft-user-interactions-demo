/*
Copyright 2018 FileThis, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
/* See https://goo.gl/OOhYW5 */
/*<link rel="manifest" href="./manifest.json">*/
/* Load any needed Web Components polyfills from the FileThis CDN */
/*
  FIXME(polymer-modulizer): the above comments were extracted
  from HTML and may be out of place here. Review them and
  then delete this comment!
*/
const $_documentContainer = document.createElement('template');

$_documentContainer.innerHTML = `<title>ft-user-interactions-demo</title><style>
            html, body {
                height: 100%;
                margin: 0;
            }
        </style><ft-user-interactions-demo style="height:100%; ">
        </ft-user-interactions-demo>`;

document.head.appendChild($_documentContainer.content);
var link = document.createElement('link');
link.setAttribute('rel', 'import');
link.setAttribute('href', './src/ft-user-interactions-demo.html');
document.getElementsByTagName('head')[0].appendChild(link);
