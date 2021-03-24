#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D CurrentFrameSampler;
uniform sampler2D PastFrameSampler;
uniform vec2 OutSize;

in vec2 texCoord;

out vec4 fragColor;

#define near 0.00004882812 
#define far 1.0

float LinearizeDepth(float depth) 
{
    return (2.0 * near * far) / (far + near - depth * (far - near));    
}

void main() {
    fragColor = texture(PastFrameSampler, texCoord);
    vec4 hmm = texture(DiffuseSampler, vec2(0.0001, 0.0001));
    if (hmm.r > 0.99 && hmm.a > 0.99 && hmm.g < 0.01 && hmm.b < 0.01) {
        vec2 oneTexel = 1.0 / OutSize;
        if (texCoord.x > oneTexel.x && texCoord.y > oneTexel.y) {
            fragColor = texture(CurrentFrameSampler, texCoord);
        } else {
            fragColor = (texture(CurrentFrameSampler, texCoord + vec2(oneTexel.x, 0.0)) + texture(CurrentFrameSampler, texCoord + vec2(0.0, oneTexel.y))) * 0.5;
        }
    }
}
