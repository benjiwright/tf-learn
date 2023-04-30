exports.handler = async function (event, context) {
  console.log("EVENT FROM LAMBDA:\n" + JSON.stringify(event));
  return { success: true };
};
