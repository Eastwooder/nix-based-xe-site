---
title: How to use Tailwind CSS in your Go programs
date: 2023-08-27
tags: 
  - go
  - tailwind
  - css
series: howto
---

<xeblog-hero ai="Nikon D3300, Holga Lens, Photo by Xe Iaso" file="grass" prompt="A dithered picture of grass, vignetted around the edges. The palette is forced to be very natural."></xeblog-hero>

When I work on some of my smaller projects, I end up hitting a point where I need more than [minimal CSS](https://github.com/Xe/Xess) configuration. I don't want to totally change my development flow to bring in a bunch of complicated toolkits or totally rewrite my frontend in React or something, I just want to make things not look like garbage. Working with CSS by itself can be annoying.

<xeblog-conv name="Aoi" mood="coffee">Heck yes it is! I don't like working with CSS because it never really feels like I'm making progress. I'm always fighting with it. It's just left me with the impression that I'm just fundamentally _bad_ at frontend work.</xeblog-conv>
<xeblog-conv name="Numa" mood="happy">TBH, you're not bad at frontend work. You're bad at design. The way you get better at design is by doing more attempts at it. You can't get better at design by avoiding it. I'm not saying you have to be a designer. I'm saying you have to be willing to try.<br /><br />Remember: ignorance is the default state.</xeblog-conv>
<xeblog-conv name="Aoi" mood="wut">You know, I never really thought about it like that. I guess I'll give it a shot.</xeblog-conv>

I've found a way to make working with CSS a lot easier for me. I've been starting to use [Tailwind](https://tailwindcss.com/) in my personal and professional projects. Tailwind is a CSS framework that makes nearly [every CSS behavior](https://tailwindcss.com/docs/utility-first) its own utility class. This means that you can make your HTML and CSS the same file, minimizing context switching between your HTML and CSS files. It also means that you can build your own components out of these utility classes. Here's an example of what it ends up looking like in practice:

```html
<div class="bg-blue-500 text-white font-bold py-2 px-4 rounded">Button</div>
```

This is a button that has a blue background, white text, is bold, has a padding of 2, and has a rounded border. This looks like a lot of CSS to write for a button, but it's all in one place and can be customized for every button. This is a lot easier to work with than having to context switch between your HTML and CSS files.

<xeblog-conv name="Aoi" mood="wut">What's that unit in `px-2`, it's padding on the X axis by two what?</xeblog-conv>
<xeblog-conv name="Mara" mood="happy">It's [rem](https://www.sitepoint.com/understanding-and-using-rem-units-in-css/), which is about 16 pixels (assuming you don't change the font size). The exact size of rem units can be confusing at first, but you end up internalizing it over time. Think about it like this: `pr-1` is about the size of a space between words.</xeblog-conv>

One of the biggest downsides is that Tailwind's compiler is written in JavaScript and distributed over [npm](https://www.npmjs.com/). This is okay for people that are experienced JavaScript Touchers, but I am not one of them. Usually when I see that something requires me to use npm, I just close the tab and move on. Thankfully, Tailwind is actually a lot easier to use than you'd think. You really just have to install the compiler (either with npm or as a Nix package) and then run it. You can even set up a watcher to automatically rebuild your CSS file when you change your HTML templates. It's a lot less overhead than you think.

## Assumptions

To make our lives easier, I'm going to assume the following things about your project:

- It is written in Go.
- You are using [`html/template`](https://pkg.go.dev/html/template) for your HTML templates.
- You have a `static` folder that has your existing static assets (eg: https://alpinejs.dev for interactive components).

<xeblog-conv name="Cadey" mood="enby" standalone>I can't reccomend Alpine.js enough. It's everything I want out of progressive JavaScript enhancement of websites. Combined with Tailwind it is a killer combination. Read more about the combination [here](https://devdojo.com/pines).</xeblog-conv>

## Setup

<details>
<summary>If you are using Nix or NixOS</summary>

Add the `tailwindcss` package to your `flake.nix`'s `devShell`:

```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: {
    devShell = nixpkgs.mkShell {
      nativeBuildInputs = [ self.nixpkgs.tailwindcss ];
    };
  };
}
```

Then you should be able to use the `tailwindcss` command in your shell. Ignore the parts about installing `tailwindcss` with `npm`, but you may want to use `npm` as a script runner or to install other tools. Any time I tell you to use `npx tailwindcss`, just mentally replace that with `tailwindcss`.

</details>

First you need to install Tailwind's CLI tool. Make sure you have `npm`/`nodejs` installed from [the official website](https://nodejs.org/en/download/). 

Then create a `package.json` file with `npm init`:

```
npm init
```

Once you finish answering the questions (realistically, none of the answers matter here), you can install Tailwind:

```
npm install --dev --save tailwindcss
```

Now you need to set up some scripts in your `package.json` file. You can do this by hand, or you can use `npm`'s built-in script runner to do it for you. This lets you build your website's CSS with commands like `npm run build` or make your CSS automatically rebuild with `npm run watch`. To do this, you need to add the following to your `package.json` file:

```json
{
  // other contents here, make sure to add a trailing comma.
  "scripts": {
    "build": "tailwindcss build -o static/css/tailwind.css",
    "watch": "tailwindcss build -o static/css/tailwind.css --watch"
  }
}
```

<xeblog-conv name="Mara" mood="hacker" standalone>It's helpful to run `npm run watch` in another terminal while you're working on your website. This will automatically rebuild your CSS file when you change your HTML templates.</xeblog-conv>

Next you need to make a `tailwind.config.js` file. This will configure Tailwind with your HTML teplate locations as well as let you set any other options. You can do this by hand, or you can use Tailwind's built-in config generator:

```
npx tailwindcss init
```

Then open it up and configure it to your liking. Here's an example of what it looks like when using [Iosevka Iaso](https://xeiaso.net/blog/iaso-fonts):

```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./tmpl/*.html"], // This is where your HTML templates / JSX files are located
  theme: {
    extend: {
      fontFamily: {
        sans: ["Iosevka Aile Iaso", "sans-serif"],
        mono: ["Iosevka Curly Iaso", "monospace"],
        serif: ["Iosevka Etoile Iaso", "serif"],
      },
    },
  },
  plugins: [],
};
```

<xeblog-conv name="Mara" mood="hacker" standalone>If you're using Iosevka Iaso fonts, make sure to import them in your base/header HTML template:</xeblog-conv>

```html
<link rel="stylesheet" href="https://cdn.xeiaso.net/static/pkg/iosevka/family.css" />
```

If you aren't serving your static assets in your Go program already, you can use Go's standard library HTTP server and [`go:embed`](https://blog.carlmjohnson.net/post/2021/how-to-use-go-embed/):

```go
//go:embed static
var static embed.FS

// assuming you have a net/http#ServeMux called `mux`
mux.Handle("/static/", http.FileServer(http.FS(static)))
```

This will bake your static assets into your Go binary, which is nice for deployment. Things you can't forget are a lot more robust than things you can forget.

Finally, add a `//go:generate` directive to your Go program to build your CSS file when you run `go generate`:

```go
//go:generate npm run build
```

When you change your HTML templates, you can run `go generate` to rebuild your CSS files.

<xeblog-conv name="Mara" mood="hacker" standalone>Running `go generate` manually like this isn't as robust as you'd get when using [`build.rs`](https://doc.rust-lang.org/cargo/reference/build-scripts.html) to automagically regenerate it at compile time, but this can be mostly fixed by having a CI check make sure that all generated files are up to date. I wish we could have nice things.</xeblog-conv>

Finally, make sure you import your Tailwind build in your HTML template:

```html
<link rel="stylesheet" href="/static/css/tailwind.css" />
```

Now you can get started with using Tailwind in your HTML templates! I hope this helps.