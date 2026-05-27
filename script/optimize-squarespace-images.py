#!/usr/bin/env python3
"""Optimize migrated Squarespace images in place.

The optimizer preserves file extensions/formats and only replaces an image when
the optimized candidate is smaller than the current file. GIFs are left alone.
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path
from tempfile import NamedTemporaryFile

from PIL import Image, ImageOps


SUPPORTED_EXTENSIONS = {".jpg", ".jpeg", ".png"}


def save_candidate(image: Image.Image, destination: Path, extension: str, quality: int) -> None:
    if extension in {".jpg", ".jpeg"}:
        if image.mode not in {"RGB", "L"}:
            background = Image.new("RGB", image.size, "white")
            if "A" in image.getbands():
                background.paste(image, mask=image.getchannel("A"))
                image = background
            else:
                image = image.convert("RGB")

        image.save(
            destination,
            format="JPEG",
            quality=quality,
            optimize=True,
            progressive=True,
        )
        return

    if extension == ".png":
        image.save(destination, format="PNG", optimize=True, compress_level=9)
        return

    raise ValueError(f"Unsupported extension: {extension}")


def optimize_image(path: Path, max_width: int, quality: int) -> tuple[bool, int, int, str]:
    original_size = path.stat().st_size
    extension = path.suffix.lower()

    if extension not in SUPPORTED_EXTENSIONS:
        return False, original_size, original_size, "skipped unsupported format"

    with Image.open(path) as opened:
        image = ImageOps.exif_transpose(opened)
        image.load()

    note_parts: list[str] = []
    if image.width > max_width:
        new_height = round(image.height * (max_width / image.width))
        image = image.resize((max_width, new_height), Image.Resampling.LANCZOS)
        note_parts.append(f"resized {max_width}w")

    with NamedTemporaryFile(delete=False, suffix=extension) as temp_file:
        temp_path = Path(temp_file.name)

    try:
        save_candidate(image, temp_path, extension, quality)
        candidate_size = temp_path.stat().st_size

        if candidate_size < original_size:
            os.replace(temp_path, path)
            note = ", ".join(note_parts) if note_parts else "optimized"
            return True, original_size, candidate_size, note

        temp_path.unlink(missing_ok=True)
        note = ", ".join(note_parts) if note_parts else "candidate not smaller"
        return False, original_size, original_size, note
    except Exception:
        temp_path.unlink(missing_ok=True)
        raise


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dir", default="assets/squarespace", help="Directory of images to optimize")
    parser.add_argument("--max-width", type=int, default=2000)
    parser.add_argument("--quality", type=int, default=82)
    args = parser.parse_args()

    image_dir = Path(args.dir)
    changed = 0
    skipped = 0
    before_total = 0
    after_total = 0

    for path in sorted(image_dir.iterdir()):
        if not path.is_file():
            continue

        original_size = path.stat().st_size
        before_total += original_size

        did_change, before, after, note = optimize_image(path, args.max_width, args.quality)
        after_total += after

        if did_change:
            changed += 1
            saved = before - after
            print(f"optimized\t{saved}\t{before}\t{after}\t{path}\t{note}")
        else:
            skipped += 1

    saved_total = before_total - after_total
    print(f"summary\tchanged={changed}\tskipped={skipped}\tbefore={before_total}\tafter={after_total}\tsaved={saved_total}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
