import vapoursynth as vs
core = vs.core

clip = video_in

# pick 120.000 or 119.880 automatically
src_num, src_den = clip.fps_num, clip.fps_den
is_23976 = abs((src_num/src_den) - (24000/1001)) < 1e-3
out_num, out_den = (120000, 1001) if is_23976 else (120, 1)

# 1) build super with pel=2 (good compromise)
super = core.mv.Super(clip, pel=2, sharp=1)

# 2) coarse pass: BIG blocks for large, uniform motion (pans)
fv32 = core.mv.Analyse(super, isb=False, blksize=32,
                       overlap=16, search=3, truemotion=True)
bv32 = core.mv.Analyse(super, isb=True,  blksize=32,
                       overlap=16, search=3, truemotion=True)

# 3) refine: medium blocks
fv16 = core.mv.Recalculate(super, fv32, blksize=16, overlap=8, search=3)
bv16 = core.mv.Recalculate(super, bv32, blksize=16, overlap=8, search=3)

# 4) refine again: small blocks to catch detail (optional; comment out if too slow)
fv8 = core.mv.Recalculate(super, fv16, blksize=8,  overlap=4, search=3)
bv8 = core.mv.Recalculate(super, bv16, blksize=8,  overlap=4, search=3)

# 5) interpolate
out = core.mv.FlowFPS(clip, super, bv8, fv8, num=out_num, den=out_den, mask=2)
out.set_output()
