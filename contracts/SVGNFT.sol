// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Strings.sol";
import "./Base64.sol";

library SVGNFT {

  function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(endIndex - startIndex);
    for (uint i = startIndex; i < endIndex; ++i) {
      result[i - startIndex] = strBytes[i];
    }
    return string(result);
  }
  
  function burierSVG(address dead_address) internal pure returns (string memory) {
    string memory baseURL = "data:image/svg+xml;base64,";
    string memory addr_string = Strings.toHexString(dead_address);
    string memory addr_part_1 = substring(addr_string, 0, 21);
    string memory addr_part_2 = substring(addr_string, 21, 42);
    string memory svg1 = 
      "<svg width='400' height='400' viewBox='0 0 400 400' fill='none' xmlns='http://www.w3.org/2000/svg'>\
      <style>\
      .title { font: 18px monospace; fill: #14cccc; text-anchor: middle; dominant-baseline: middle; }\
      .heavy { font: 12px monospace; fill: #14cccc; text-anchor: middle; dominant-baseline: middle; }\
      </style>\
      <rect width='400' height='400' fill='black'/>\
      <path d='M100 77.7601C170 7.4133 230 7.4133 300 77.7601V375H100V77.7601Z' fill='url(#paint0_linear_141_8)'/>\
      <path d='M135.963 117.576L126 117.308L129.581 116.478C147.553 112.31 158.125 93.6729 152.479 76.1093C168.948 90.8837 158.08 118.171 135.963 117.576Z' fill='url(#paint1_linear_141_8)'/>\
      <defs>\
      <linearGradient id='paint0_linear_141_8' x1='200' y1='17.3213' x2='200' y2='375' gradientUnits='userSpaceOnUse'>\
      <stop offset='0.0001' stop-color='#14CCCC' stop-opacity='0'/>\
      <stop offset='0.0002' stop-color='#14CCCC' stop-opacity='0.3'/>\
      <stop offset='0.967557' stop-color='#14CCCC' stop-opacity='0'/>\
      <stop offset='1' stop-color='#14CCCC'/>\
      <stop offset='1' stop-color='#14CCCC' stop-opacity='0.5'/>\
      </linearGradient>\
      <linearGradient id='paint1_linear_141_8' x1='159.513' y1='70.7451' x2='108.155' y2='120.148' gradientUnits='userSpaceOnUse'>\
      <stop stop-color='#14CCCC'/>\
      <stop offset='1' stop-color='#14CCCC' stop-opacity='0'/>\
      </linearGradient>\
      </defs>\
      <text x='50%' y='150' class='title'>0xDeadList</text>\
      <text x='50%' y='220' class='heavy'>Dead Address</text>";
    string memory svg2 = string(abi.encodePacked("<text x='50%' y='240' class='heavy'>", addr_part_1, "</text>"));
    string memory svg3 = string(abi.encodePacked("<text x='50%' y='260' class='heavy'>", addr_part_2, "</text>"));
    string memory svg4 = "</svg>";
    string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg1, svg2, svg3, svg4))));
    return string(abi.encodePacked(baseURL, svgBase64Encoded));
  }

  function tombstoneSVG(address dead_address, uint256 private_key)
  internal pure returns (string memory) {
    string memory baseURL = "data:image/svg+xml;base64,";
    string memory addr_string = Strings.toHexString(dead_address);
    string memory addr_part_1 = substring(addr_string, 0, 21);
    string memory addr_part_2 = substring(addr_string, 21, 42);
    string memory private_key_string = Strings.toHexString(private_key, 32);
    string memory private_key_part_1 = substring(private_key_string, 0, 33);
    string memory private_key_part_2 = substring(private_key_string, 33, 66);
    string memory svg1 = 
      "<svg width='400' height='400' viewBox='0 0 400 400' fill='none' xmlns='http://www.w3.org/2000/svg'>\
      <style>\
      .title { font: 30px monospace; fill: #14cccc; text-anchor: middle; dominant-baseline: middle; }\
      .private { font: 14px monospace; fill: #ec6059; text-anchor: middle; dominant-baseline: middle; }\
      .heavy { font: 14px monospace; fill: #14cccc; text-anchor: middle; dominant-baseline: middle; }\
      </style>\
      <rect width='400' height='400' fill='black'/>\
      <g filter='url(#filter0_i_184_22)'>\
      <rect x='25' y='25' width='350' height='350' rx='10' fill='#14CCCC' fill-opacity='0.2'/>\
      </g>\
      <defs>\
      <filter id='filter0_i_184_22' x='25' y='25' width='350' height='350' filterUnits='userSpaceOnUse' color-interpolation-filters='sRGB'>\
      <feFlood flood-opacity='0' result='BackgroundImageFix'/>\
      <feBlend mode='normal' in='SourceGraphic' in2='BackgroundImageFix' result='shape'/>\
      <feColorMatrix in='SourceAlpha' type='matrix' values='0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0' result='hardAlpha'/>\
      <feOffset/>\
      <feGaussianBlur stdDeviation='7.5'/>\
      <feComposite in2='hardAlpha' operator='arithmetic' k2='-1' k3='1'/>\
      <feColorMatrix type='matrix' values='0 0 0 0 0.08 0 0 0 0 0.8 0 0 0 0 0.8 0 0 0 1 0'/>\
      <feBlend mode='normal' in2='shape' result='effect1_innerShadow_184_22'/>\
      </filter>\
      </defs>\
      <text x='50%' y='80' class='title'>Tombstone</text>\
      <text x='50%' y='140' class='private'>Private Key</text>";
    string memory svg2 = string(abi.encodePacked("<text x='50%' y='175' class='private'>", private_key_part_1, "</text>"));
    string memory svg3 = string(abi.encodePacked("<text x='50%' y='200' class='private'>", private_key_part_2, "</text>"));
    string memory svg4 = "<text x='50%' y='240' class='heavy'>Address</text>";
    string memory svg5 = string(abi.encodePacked("<text x='50%' y='275' class='heavy'>", addr_part_1, "</text>"));
    string memory svg6 = string(abi.encodePacked("<text x='50%' y='300' class='heavy'>", addr_part_2, "</text>"));
    string memory svg7 = "</svg>";
    string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg1, svg2, svg3, svg4, svg5, svg6, svg7))));
    return string(abi.encodePacked(baseURL, svgBase64Encoded));
  }
}
