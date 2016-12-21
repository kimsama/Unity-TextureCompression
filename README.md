# TextureCompression


## Spine with Alpha-Mask

As mentioned on [this post](https://github.com/keijiro/unity-alphamask), you can also recude [Spine](https://github.com/EsotericSoftware/spine-runtimes)'s atlas image size up to 1/4 compared with RGBA32 format.

> Note that RGBA32 format size of 1024x1024 image takes 4M.

So it takes less loading time and makes a user feel the game runs smoothly.

Some glitch (or  noise) can be shown when alpha-mask is used is barely noticed if you corretly use alpha-mask  so it can be enoughly ignored in run time.

### Edge

A seam (or outline) can be found if the edge of a sprite image in the atlas image has translucent outline.

<p align="center">
  <img src="./images/edge.png" >
</p>

There is no way to remove that seam with programmatic way. So modifying that outlines found in the atlas image as not too much translucent with any image processing tool such as Photoshop will get better output.

### Order in Layer

You may also need to modify original shader code which can be found on [here](https://github.com/keijiro/unity-alphamask/blob/master/Assets/SpriteWithMask.shader) to support correct sorting order of the spine image when it is rendered on run time.

<p align="center">
  <img src="./images/sorting-layer.png" >
</p>

To do sort of layers it just needs to add _"Transparent"_ value to _"Queue"_ key within Tags.

``` cpp
Shader "Custom/SpriteWithMask"
{
	Properties {
		_MainTex ("Base", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		_Color ("Color", Color) = (0.5, 0.5, 0.5, 0.5)
	}
	SubShader {
            // Add 'Transparent' value to "Queue" key
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			LOD 100

			Fog{ Mode Off }
			Cull Off
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			CGPROGRAM
```

> You don't need to apply "Spine/Skeleton" shader for a spine image. Any 2D sprite supported shader may work fine with spine's skeleton animation.

## Conclusion

There are a few other texture compression techniques which reduce bpp of the image.


(C) 2016 Kim Hyoun Woo
