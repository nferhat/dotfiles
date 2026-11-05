// Copied from a gist i forgot where I got it though
// NOTE: this shader draws the cursor itself, so hide ghostty's:
//     cursor-opacity = 0

const float DURATION   = 0.15; // seconds per glide
const float MAX_JUMP   = 32.0;  // in cell heights, anything further just snaps
const float BG_OPACITY = 0.95; // MUST match background-opacity, used to find glyph pixels

// easeOutExpo, the x == 1 check is bc 2^-10 never actually reaches 1
float ease(float x) { return x >= 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * x); }

// NOTE: cursor rects are (left, top, w, h), y-up, so the rect spans [y - h, y]
vec2 center(vec4 r) { return vec2(r.x + r.z * 0.5, r.y - r.w * 0.5); }

bool inside(vec2 p, vec2 c, vec2 halfSize) {
    vec2 d = abs(p - c);
    return d.x <= halfSize.x && d.y <= halfSize.y;
}

// how much of this pixel the rect covers (box filter). pixel-aligned rects
// come out exactly 0/1, so the cursor stays crisp at rest
float coverage(vec2 p, vec2 c, vec2 halfSize) {
    vec2 a = clamp(halfSize - abs(p - c) + 0.5, 0.0, 1.0);
    return a.x * a.y;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 tex = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = tex;

    if (iCursorVisible == 0 || iFocus == 0) return;

    vec4 cur  = iCurrentCursor;
    vec4 prev = iPreviousCursor;

    // all-zero prev = first frame, and far jumps shouldn't glide across the screen
    float dist = length(center(cur) - center(prev));
    if (prev.z * prev.w == 0.0 || dist > MAX_JUMP * cur.w) prev = cur;

    float e = ease(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    vec2 c        = mix(center(prev), center(cur), e);
    vec2 halfSize = mix(prev.zw, cur.zw, e) * 0.5;

    float cov = coverage(fragCoord, c, halfSize);
    if (cov <= 0.0) return;

    // XXX: hacky, opaque pixels in the target cell = glyph, keep them on top
    // so the char under a block cursor stays readable. bar/underline just draw over
    bool glyph = iCurrentCursorStyle == CURSORSTYLE_BLOCK
        && tex.a > BG_OPACITY + 0.01
        && inside(fragCoord, center(cur), cur.zw * 0.5);
    fragColor = glyph ? tex : mix(tex, vec4(iCurrentCursorColor.rgb, 1.0), cov);
}
