#ifdef GL_ES
precision highp float;
#endif

#define PI 3.141592654
#define PI2 (3.141592654 * 2.)

#define PATTERN_DIM 128.0

#define GROUP_P1 0
#define GROUP_P2 1
#define GROUP_PM 2
#define GROUP_PG 3
#define GROUP_CM 4
#define GROUP_PMM 5
#define GROUP_PMG 6
#define GROUP_PGG 7

uniform int group;
uniform float offset;
uniform float rotation;
uniform vec2 scaling;

uniform sampler2D sampler1;

void main(void) {
  vec2 pos = gl_FragCoord.xy;

  float xt =  pos.x * cos(rotation) * scaling.x + pos.y * sin(rotation) * scaling.y;
  float yt = -pos.x * sin(rotation) * scaling.x + pos.y * cos(rotation) * scaling.y;

  if (group == GROUP_P1) {
    
    float oyt = yt;
    yt = mod(yt, PATTERN_DIM) / PATTERN_DIM;
    float widthDim = PATTERN_DIM - offset;
    float from  = offset / PATTERN_DIM * yt;
    float to = 1. - offset * (1. - yt) / PATTERN_DIM;
    xt = mod(xt - offset * (oyt / PATTERN_DIM), widthDim) / widthDim * (to - from) + from;

  } else if (group == GROUP_P2) {
    
    float widthDim = PATTERN_DIM - offset;
    float oyt = yt;
    if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
      yt = mod(yt, PATTERN_DIM) / PATTERN_DIM;
      float from  = offset / PATTERN_DIM * yt;
      float to = 1. - offset * (1. - yt) / PATTERN_DIM;
      xt = mod(xt - offset * (oyt / PATTERN_DIM), widthDim) / widthDim * (to - from) + from;

    } else {
      yt = 1. - mod(yt, PATTERN_DIM) / PATTERN_DIM;
      float from  = 1. - offset / PATTERN_DIM * (1. - yt);
      float to = offset * yt / PATTERN_DIM;
      xt = mod(xt - offset * (oyt / PATTERN_DIM), widthDim) / widthDim * (to - from) + from;

    }

  } else if (group == GROUP_PM) {
    
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;

    if (mod(yt / heightDim, 2.0) < 1.0) {
      yt = mod(yt, heightDim) / heightDim * (to - from) + from;

    } else {
      yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
    }

  } else if (group == GROUP_PG) {
    
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      yt = mod(yt, heightDim) / heightDim * (to - from) + from;

    } else {
      yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
    }
    
    xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;

  } else if (group == GROUP_CM) {
    
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, heightDim) / heightDim;
    
    if (mod(yt / heightDim, 2.0) < 1.0) {
      float xfrom = (1. - ytmod) / 2.;
      float xto = ytmod / 2. + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt = xtmod;
        yt = ytmod * (to - from) + from;
      } else {
        xt = xtmod - .5;
        yt = 1. - (ytmod * (to - from) + from);
      }
    } else {
      float xfrom = ytmod / 2.;
      float xto = (1. - ytmod) * .5 + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt = xtmod;
        yt = (1. - ytmod) * (to - from) + from;
      } else {
        xt = xtmod - .5;
        yt = 1. - ((1. - ytmod) * (to - from) + from);
      }
    }
  } else if (group == GROUP_PMM) {
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    } else {
      xt = 1. - mod(xt, PATTERN_DIM) / PATTERN_DIM;
    }
    
    if (mod(yt / heightDim, 2.0) < 1.0) {
      yt = mod(yt, heightDim) / heightDim * (to - from) + from;
    } else {
      yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
    }
  } else if (group == GROUP_PMG) {
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      if (mod(yt / heightDim, 2.0) < 1.0) {
        xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = mod(yt, heightDim) / heightDim * (to - from) + from;
      } else {
        xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
      }
    } else {
      if (mod(yt / heightDim, 2.0) < 1.0) {
        xt = 1. - mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
      } else {
        xt = 1. - mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = mod(yt, heightDim) / heightDim * (to - from) + from;
      }
    }
  } else if (group == GROUP_PGG) {
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, heightDim) / heightDim;
    
    if (mod(yt / heightDim, 2.0) < 1.0) {
      float xfrom = (1. - ytmod) / 2.;
      float xto = ytmod / 2. + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt = xtmod;
        yt = ytmod * (to - from) + from;
      } else {
        xt = xtmod - .5;
        yt = 1. - (ytmod * (to - from) + from);
      }
    } else {
      float xfrom = ytmod / 2.;
      float xto = (1. - ytmod) * .5 + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt =  1. - xtmod;
        yt = (1. - ytmod) * (to - from) + from;
      } else {
        xt = (1. - xtmod) - .5;
        yt = ytmod * (to - from) + from;
      }
    }
    
  } else {
    
    xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    yt = mod(yt, PATTERN_DIM) / PATTERN_DIM;

  }
  
  vec4 color = texture2D(sampler1, vec2(xt, yt));

  gl_FragColor = color;
}
